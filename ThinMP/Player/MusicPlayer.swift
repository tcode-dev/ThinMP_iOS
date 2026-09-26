//
//  MusicPlayer.swift
//  ThinMP
//
//  Created by tk on 2020/01/31.
//

import MediaPlayer
import Observation

/// 通知は OperationQueue.main、Timer はメインの RunLoop で届くので、ブロックの中では MainActor.assumeIsolated で自分のメソッドを呼ぶ
@Observable
final class MusicPlayer {
    /// 再生位置がここまでなら prev() で前の曲へ、過ぎていれば曲の先頭へ戻る
    private let prevThresholdSecond: Double = 3

    private(set) var isPlaying: Bool = false
    private(set) var song: SongModel?
    /// 再生位置のスライダーが Binding で書き換えるので、これだけは外から書ける
    var currentSecond: Double = 0
    private(set) var durationSecond: Double = 1
    private(set) var repeatMode: MPMusicRepeatMode = .none
    private(set) var isShuffle: Bool = false
    private(set) var isFavoriteArtist: Bool = false
    private(set) var isFavoriteSong: Bool = false

    /// 再生する曲があるか
    var isActive: Bool {
        return song != nil
    }

    private let playerConfig: PlayerConfig
    private let favoriteArtistRepository: FavoriteArtistRepositoryProtocol
    private let favoriteSongRepository: FavoriteSongRepositoryProtocol
    private let player: MPMusicPlayerController
    @ObservationIgnored private var timer: Timer?
    /// 再生画面が表示されている間だけ true。true かつ再生中のときだけ timer を回す
    @ObservationIgnored private var isProgressActive = false
    /// スライダーを掴んでいる間は true。timer が currentSecond を上書きしないようにする
    @ObservationIgnored private var isSeeking = false
    @ObservationIgnored private var observers: [NSObjectProtocol] = []

    init(
        playerConfig: PlayerConfig = PlayerConfig(),
        favoriteArtistRepository: FavoriteArtistRepositoryProtocol = FavoriteArtistRepository(),
        favoriteSongRepository: FavoriteSongRepositoryProtocol = FavoriteSongRepository()
    ) {
        self.playerConfig = playerConfig
        self.favoriteArtistRepository = favoriteArtistRepository
        self.favoriteSongRepository = favoriteSongRepository
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = playerConfig.repeatMode
        player.shuffleMode = playerConfig.shuffleMode
        setRepeat()
        setShuffle()
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }

    /// list[currentIndex] から再生する。currentIndex が範囲外なら何もしない
    func start(list: [SongModel], currentIndex: Int) {
        guard list.indices.contains(currentIndex) else {
            return
        }

        if player.playbackState == .playing {
            player.stop()
        }

        let items = MPMediaItemCollection(items: list.map { $0.item })
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: items)

        descriptor.startItem = list[currentIndex].item
        player.setQueue(with: descriptor)
        play()
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    /// currentSecond は再生画面を表示中に timer が進めるだけなので、判定は再生位置そのもので行う
    func prev() {
        if player.currentPlaybackTime <= prevThresholdSecond {
            player.skipToPreviousItem()
        } else {
            player.skipToBeginning()
        }
    }

    func next() {
        player.skipToNextItem()
    }

    /// スライダーを掴んだときに呼ぶ。離すまで currentSecond はスライダーが持つ
    func beginSeek() {
        isSeeking = true
    }

    /// スライダーを離したときに呼ぶ。スライダーの位置(currentSecond)まで飛ぶ
    func endSeek() {
        isSeeking = false
        player.currentPlaybackTime = currentSecond
    }

    /// 再生画面を表示したときに呼ぶ。以降は再生 / 一時停止に合わせて timer を回したり止めたりする
    func startProgress() {
        isProgressActive = true
        updateTime()
        updateTimer()
    }

    /// 再生画面を閉じた、またはバックグラウンドに入ったときに呼ぶ
    func stopProgress() {
        isProgressActive = false
        updateTimer()
    }

    /// なし → 全曲 → 1 曲 → なし の順で切り替える
    func changeRepeat() {
        switch player.repeatMode {
        case .none: player.repeatMode = .all
        case .all: player.repeatMode = .one
        default: player.repeatMode = .none
        }

        setRepeat()
        playerConfig.repeatMode = player.repeatMode
    }

    func shuffle() {
        player.shuffleMode = player.shuffleMode == .off ? .songs : .off
        setShuffle()
        playerConfig.shuffleMode = player.shuffleMode
    }

    /// 再生中の曲のアーティストをお気に入りに入れる / 外す
    func toggleFavoriteArtist() {
        guard let artistId = song?.artistId else {
            return
        }

        isFavoriteArtist = favoriteArtistRepository.toggle(artistId: artistId)
    }

    /// 再生中の曲をお気に入りに入れる / 外す
    func toggleFavoriteSong() {
        guard let songId = song?.songId else {
            return
        }

        isFavoriteSong = favoriteSongRepository.toggle(songId: songId)
    }

    /// お気に入りの状態をストアから読み直す
    /// 曲が切り替わったときと、ストアの保存通知(他の画面での登録 / 解除)を受けたときに呼ぶ
    private func reloadFavorite() {
        isFavoriteArtist = (song?.artistId).map { favoriteArtistRepository.exists(artistId: $0) } ?? false
        isFavoriteSong = (song?.songId).map { favoriteSongRepository.exists(songId: $0) } ?? false
    }

    private func setSong() {
        if let item = player.nowPlayingItem {
            song = SongModel(item: item)
            resetTime()
        } else {
            song = nil
            currentSecond = 0
            durationSecond = 1
        }

        // 曲が無くなっても再生画面は開いたまま残るので、そのときもお気に入りの表示を読み直して消す
        reloadFavorite()
    }

    /// ブロックは NotificationCenter が持ち続けるので、self を強く掴むと deinit が呼ばれなくなる
    private func addObserver() {
        observers.append(NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.setSong()
            }
        })

        observers.append(NotificationCenter.default.addObserver(
            forName: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.playbackStateDidChangeCallback()
            }
        })

        // 一覧のメニューなど、再生画面の外でお気に入りが変わっても表示を合わせる
        // MusicPlayer は Repository 越しにしかストアを知らないので、object は絞らない(RegisterToggleButtonView と同じ)
        observers.append(NotificationCenter.default.addObserver(
            forName: .swiftDataStoreDidSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.reloadFavorite()
            }
        })
    }

    /// Control Center やイヤホンからの操作もここに届くので、timer の開始 / 停止はここで決める
    /// キューの終端(stopped)と電話などの割り込み(interrupted)でも止まったことにしないと、
    /// 一時停止アイコンのまま押しても効かなくなる。seeking は長押し早送り中で、音は進んでいる
    private func playbackStateDidChangeCallback() {
        switch player.playbackState {
        case .playing, .seekingForward, .seekingBackward:
            isPlaying = true
        case .paused, .stopped, .interrupted:
            isPlaying = false
        @unknown default:
            break
        }

        updateTimer()
    }

    private func resetTime() {
        let second = player.nowPlayingItem?.playbackDuration ?? 0
        durationSecond = second > 0 ? second : 1
        updateTime()
    }

    private func updateTime() {
        if isSeeking {
            return
        }

        currentSecond = Double(player.currentPlaybackTime)
    }

    /// 再生画面が表示中かつ再生中のときだけ 1 秒ごとに currentSecond を更新する
    private func updateTimer() {
        timer?.invalidate()
        timer = nil

        guard isProgressActive, isPlaying else {
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            MainActor.assumeIsolated {
                self?.updateTime()
            }
        })
    }

    private func setRepeat() {
        repeatMode = player.repeatMode
    }

    private func setShuffle() {
        isShuffle = player.shuffleMode == .songs
    }

    isolated deinit {
        // ブロック形式の observer は removeObserver(self, ...) では外れないので token で外す
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        // 繰り返しの Timer は RunLoop が持ち続けるので、止めないと self が消えても回り続ける
        timer?.invalidate()

        player.endGeneratingPlaybackNotifications()
    }
}

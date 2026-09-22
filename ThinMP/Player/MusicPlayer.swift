//
//  MusicPlayer.swift
//  ThinMP
//
//  Created by tk on 2020/01/31.
//

import MediaPlayer

// 通知は OperationQueue.main、Timer はメインの RunLoop で届き、@Published は View から読まれるので
// 全体をメインアクターに隔離する。Register(SwiftData)もここから触る
@MainActor
class MusicPlayer: ObservableObject {
    private let PREV_SECOND: Double = 3

    @Published var isActive: Bool = false
    @Published var isPlaying: Bool = false
    @Published var song: SongModel?
    @Published var currentSecond: Double = 0
    @Published var durationSecond: Double = 1
    @Published var repeatMode: MPMusicRepeatMode = .none
    @Published var isShuffle: Bool = false
    @Published var isFavoriteArtist: Bool = false
    @Published var isFavoriteSong: Bool = false

    private let playerConfig: PlayerConfig
    private let favoriteArtistRegister: FavoriteArtistRegisterProtocol
    private let favoriteSongRegister: FavoriteSongRegisterProtocol
    private let player: MPMusicPlayerController
    private var timer: Timer?
    /// 再生画面が表示されている間だけ true。true かつ再生中のときだけ timer を回す
    private var isProgressActive = false
    /// スライダーを掴んでいる間は true。timer が currentSecond を上書きしないようにする
    private var isSeeking = false
    private var observers: [NSObjectProtocol] = []

    init(
        playerConfig: PlayerConfig = PlayerConfig(),
        favoriteArtistRegister: FavoriteArtistRegisterProtocol = FavoriteArtistRegister(),
        favoriteSongRegister: FavoriteSongRegisterProtocol = FavoriteSongRegister()
    ) {
        self.playerConfig = playerConfig
        self.favoriteArtistRegister = favoriteArtistRegister
        self.favoriteSongRegister = favoriteSongRegister
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = playerConfig.repeatMode
        player.shuffleMode = playerConfig.shuffleMode
        setRepeat()
        setShuffle()
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }

    func start(list: [SongModel], currentIndex: Int) {
        if player.playbackState == MPMusicPlaybackState.playing {
            player.stop()
        }

        let items = MPMediaItemCollection(items: list.map { $0.media.representativeItem! as MPMediaItem })
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: items)

        descriptor.startItem = list[currentIndex].media.representativeItem
        player.setQueue(with: descriptor)
        play()
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func prev() {
        if currentSecond <= PREV_SECOND {
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
    func favoriteArtist() {
        guard let artistId = song?.artistId else {
            return
        }

        if favoriteArtistRegister.exists(artistId: artistId) {
            favoriteArtistRegister.delete(artistId: artistId)
        } else {
            favoriteArtistRegister.add(artistId: artistId)
        }

        isFavoriteArtist.toggle()
    }

    /// 再生中の曲をお気に入りに入れる / 外す
    func favoriteSong() {
        guard let songId = song?.songId else {
            return
        }

        if favoriteSongRegister.exists(songId: songId) {
            favoriteSongRegister.delete(songId: songId)
        } else {
            favoriteSongRegister.add(songId: songId)
        }

        isFavoriteSong.toggle()
    }

    /// お気に入りの状態をストアから読み直す。他の画面で登録 / 解除されたあとに呼ぶ
    func setFavorite() {
        setFavoriteArtist()
        setFavoriteSong()
    }

    private func setSong() {
        if let item = player.nowPlayingItem {
            song = SongModel(media: MPMediaItemCollection(items: [item]))
            resetTime()
            setFavorite()
            isActive = true
        } else {
            currentSecond = 0
            durationSecond = 1
            isActive = false
        }
    }

    private func addObserver() {
        observers.append(NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main
        ) { _ in
            MainActor.assumeIsolated {
                self.nowPlayingItemDidChangeCallback()
            }
        })

        observers.append(NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main
        ) { _ in
            MainActor.assumeIsolated {
                self.playbackStateDidChangeCallback()
            }
        })
    }

    private func nowPlayingItemDidChangeCallback() {
        setSong()
    }

    /// Control Center やイヤホンからの操作もここに届くので、timer の開始 / 停止はここで決める
    private func playbackStateDidChangeCallback() {
        switch player.playbackState {
        case MPMusicPlaybackState.playing:
            isPlaying = true
        case MPMusicPlaybackState.paused:
            isPlaying = false
        default:
            break
        }

        updateTimer()
    }

    private func setFavoriteArtist() {
        isFavoriteArtist = (song?.artistId).map { favoriteArtistRegister.exists(artistId: $0) } ?? false
    }

    private func setFavoriteSong() {
        isFavoriteSong = (song?.songId).map { favoriteSongRegister.exists(songId: $0) } ?? false
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

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            MainActor.assumeIsolated {
                self.updateTime()
            }
        })
    }

    private func setRepeat() {
        repeatMode = player.repeatMode
    }

    private func setShuffle() {
        isShuffle = player.shuffleMode == .songs
    }

    deinit {
        // ブロック形式の observer は removeObserver(self, ...) では外れないので token で外す
        observers.forEach { NotificationCenter.default.removeObserver($0) }

        player.endGeneratingPlaybackNotifications()
    }
}

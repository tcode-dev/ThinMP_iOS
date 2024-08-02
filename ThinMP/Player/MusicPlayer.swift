//
//  MusicPlayer.swift
//  ThinMP
//
//  Created by tk on 2020/01/31.
//

import MediaPlayer

class MusicPlayer: ObservableObject, MediaPlayerProtocol {
    private let PREV_SECOND: Double = 3

    @Published var isActive: Bool = false
    @Published var isPlaying: Bool = false
    @Published var song: SongModel?
    @Published var currentSecond: Double = 0
    @Published var durationSecond: Double = 1
    @Published var isRepeatOff: Bool = true
    @Published var isRepeatOne: Bool = false
    @Published var isRepeatAll: Bool = false
    @Published var shuffleMode: Bool = false
    @Published var isFavoriteArtist: Bool = false
    @Published var isFavoriteSong: Bool = false

    private let playerConfig: PlayerConfig
    private let player: MPMusicPlayerController
    private var timer: Timer?
    private var isBackground = false
    private var isFirst = false
    private var nowPlayingItemDidChangeDebounceTimer: Timer?
    private var playbackStateDidChangeDebounceTimer: Timer?
    private let debounceTimeInterval = 0.1

    init() {
        playerConfig = PlayerConfig()
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = playerConfig.getRepeat()
        player.shuffleMode = playerConfig.getShuffle()
        setRepeat()
        setShuffle()
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }

    func start(list: [SongModel], currentIndex: Int) {
        stop()
        song = list[currentIndex]

        let items = MPMediaItemCollection(items: list.map { $0.media.representativeItem! as MPMediaItem })
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: items)

        descriptor.startItem = song?.media.representativeItem
        player.setQueue(with: descriptor)
        doPlay()
        setFavorite()
        isFirst = true
        isActive = true
    }

    func play() {
        doPlay()
        startProgress()
    }

    func pause() {
        doPause()
        stopProgress()
    }

    func prev() {
        if isPlaying {
            playPrev()
        } else {
            doPrev()
        }
    }

    func next() {
        if isPlaying {
            playNext()
        } else {
            doNext()
        }
    }

    func seek(time: TimeInterval) {
        player.currentPlaybackTime = time
    }

    func immediateUpdateTime() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { _ in
            self.updateTime()
        })
    }

    func startProgress() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateTime()
        })
    }

    func stopProgress() {
        timer?.invalidate()
    }

    func setBackground(background: Bool) {
        isBackground = background
    }

    func changeRepeat() {
        player.repeatMode = player.repeatMode == .none ? .all
            : player.repeatMode == .all ? .one
            : .none
        setRepeat()
        playerConfig.setRepeat(value: player.repeatMode)
    }

    func shuffle() {
        player.shuffleMode = player.shuffleMode == .off ? .songs : .off
        setShuffle()
        playerConfig.setShuffle(value: player.shuffleMode)
    }

    func favoriteArtist() {
        if let artistId = song?.artistId {
            let register = FavoriteArtistRegister()

            if register.exists(artistId: artistId) {
                register.delete(artistId: artistId)
            } else {
                register.add(artistId: artistId)
            }

            isFavoriteArtist.toggle()
        }
    }

    func favoriteSong() {
        let register = FavoriteSongRegister()
        let songId = songId()

        if register.exists(songId: songId) {
            register.delete(songId: songId)
        } else {
            register.add(songId: songId)
        }

        isFavoriteSong.toggle()
    }

    func setFavorite() {
        setFavoriteArtist()
        setFavoriteSong()
    }

    func songId() -> SongId {
        return SongId(id: player.nowPlayingItem!.persistentID)
    }

    func getCurrentSong() -> SongModel? {
        return song
    }

    private func setSong() {
        if player.nowPlayingItem != nil {
            song = SongModel(media: MPMediaItemCollection(items: [player.nowPlayingItem! as MPMediaItem]))
            player.skipToBeginning()
            resetTime()
            isActive = true
        } else {
            currentSecond = 0
            durationSecond = 1
            isActive = false
        }
    }

    private func doPlay() {
        isPlaying = true

        player.prepareToPlay()
        player.play()
    }

    private func doPause() {
        isPlaying = false
        player.pause()
    }

    private func stop() {
        if !isPlaying {
            return
        }

        isPlaying = false
        player.stop()
    }

    private func doPrev() {
        stop()

        if currentSecond <= PREV_SECOND {
            player.skipToPreviousItem()
            setSong()
        } else {
            player.skipToBeginning()
            resetTime()
        }
    }

    private func playPrev() {
        doPrev()
        doPlay()
    }

    private func doNext() {
        stop()
        player.skipToNextItem()
        setSong()
        resetTime()
    }

    private func playNext() {
        doNext()
        doPlay()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main
        ) { _ in
            self.nowPlayingItemDidChangeCallback()
        }

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main
        ) { _ in
            self.playbackStateDidChangeCallback()
        }
    }

    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player
        )

        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player
        )
    }

    private func nowPlayingItemDidChangeCallback() {
        setSong()

        if player.repeatMode == .none, player.indexOfNowPlayingItem == 0, !isFirst {
            isPlaying = false
        }

        isFirst = false
    }

    private func playbackStateDidChangeCallback() {
        if isPlaying, !isBackground {
            return
        }

        switch player.playbackState {
        case MPMusicPlaybackState.stopped:

            break
        case MPMusicPlaybackState.playing:
            isPlaying = true

        case MPMusicPlaybackState.paused:
            isPlaying = false

        case MPMusicPlaybackState.interrupted:

            break
        case MPMusicPlaybackState.seekingForward:

            break
        case MPMusicPlaybackState.seekingBackward:

            break
        default:

            break
        }
    }

    private func setFavoriteArtist() {
        if let artistId = song?.artistId {
            let favoriteArtistRegister = FavoriteArtistRegister()

            isFavoriteArtist = favoriteArtistRegister.exists(artistId: artistId)
        }
    }

    private func setFavoriteSong() {
        let register = FavoriteSongRegister()

        isFavoriteSong = register.exists(songId: songId())
    }

    private func resetTime() {
        let second = player.nowPlayingItem?.playbackDuration ?? 0
        durationSecond = second > 0 ? second : 1
        updateTime()
    }

    private func updateTime() {
        currentSecond = Double(player.currentPlaybackTime)
    }

    private func setRepeat() {
        isRepeatOff = player.repeatMode == .none
        isRepeatOne = player.repeatMode == .one
        isRepeatAll = player.repeatMode == .all
    }

    private func setShuffle() {
        shuffleMode = player.shuffleMode == .songs
    }

    // 再生開始時にMPMusicPlayerControllerNowPlayingItemDidChangeが20回くらい呼ばれる
    // debounceを使用して一定時間内に複数回発生した通知を1回にまとめる
    private func nowPlayingItemDidChangeDebounce(action: @escaping () -> Void) {
        nowPlayingItemDidChangeDebounceTimer?.invalidate()
        nowPlayingItemDidChangeDebounceTimer = Timer.scheduledTimer(withTimeInterval: debounceTimeInterval, repeats: false) { _ in
            action()
        }
    }

    private func playbackStateDidChangeDebounce(action: @escaping () -> Void) {
        playbackStateDidChangeDebounceTimer?.invalidate()
        playbackStateDidChangeDebounceTimer = Timer.scheduledTimer(withTimeInterval: debounceTimeInterval, repeats: false) { _ in
            action()
        }
    }

    deinit {
        removeObserver()

        player.endGeneratingPlaybackNotifications()
     }
}

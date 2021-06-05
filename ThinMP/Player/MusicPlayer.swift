//
//  MusicPlayer.swift
//  ThinMP
//
//  Created by tk on 2020/01/31.
//

import MediaPlayer

class MusicPlayer: ObservableObject {
    static let REPEAT_OFF: Int = 0
    static let REPEAT_ONE: Int = 1
    static let REPEAT_ALL: Int = 2
    static let SHUFFLE_ON: Bool = true
    static let SHUFFLE_OFF: Bool = false

    private let PREV_SECOND: Double = 3

    @Published var isActive: Bool = false
    @Published var isPlaying: Bool = false
    @Published var song: SongModel?
    @Published var currentSecond: Double = 0
    @Published var durationSecond: Double = 0
    @Published var isRepeatOff: Bool = true
    @Published var isRepeatOne: Bool = false
    @Published var isRepeatAll: Bool = false
    @Published var shuffleMode: Bool = false
    @Published var isFavoriteArtist: Bool = false
    @Published var isFavoriteSong: Bool = false

    private let playerConfig: PlayerConfig
    private let player: MPMusicPlayerController
    private var playerState: MPMusicPlaybackState
    private var playingList: PlayingList
    private var repeatMode: Int
    private var timer: Timer?

    init() {
        playerConfig = PlayerConfig()
        playerState = MPMusicPlaybackState.stopped
        playingList = PlayingList(list: [], currentIndex: 0)
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = .none
        repeatMode = playerConfig.getRepeat()
        shuffleMode = playerConfig.getShuffle()
        setRepeat()
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }

    func start(list:[SongModel], currentIndex: Int) {
        playingList = PlayingList(list: list, currentIndex: currentIndex)

        if (shuffleMode) {
            playingList.shuffle(shuffleMode: shuffleMode)
        }

        stop()
        setSong()
        setFavoriteArtist()
        setFavoriteSong()
        play();

        isActive = true
    }

    func setSong() {
        song = playingList.getSong()
        durationSecond = Double(song?.media.representativeItem?.playbackDuration ?? 0)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: song!.media)

        player.setQueue(with: descriptor)
        seek(time: 0)
        updateTime()
    }

    func play() {
        isPlaying = true
        player.play()
    }

    func pause() {
        isPlaying = false
        playerState = MPMusicPlaybackState.paused
        player.pause()
    }

    func stop() {
        if (!isPlaying) {
            return
        }

        isPlaying = false
        playerState = MPMusicPlaybackState.paused
        player.stop()
    }

    func prev() {
        stop()
        if (currentSecond <= PREV_SECOND) {
            playingList.prev()
            setSong()
        } else {
            seek(time: 0)
            updateTime()
        }
    }

    func playPrev() {
        isPlaying = false
        prev()
        play()
    }

    func next() {
        stop()
        playingList.next()
        setSong()
    }

    func playNext() {
        next()
        play()
    }

    func autoPlay() {
        if (isRepeatAll) {
            playNext()
        } else if (isRepeatOff) {
            if (playingList.hasNext()) {
                playNext()
            } else {
                next()
            }
        } else if (isRepeatOne) {
            setSong()
            play()
        }
    }

    func seek(time: TimeInterval) {
        player.currentPlaybackTime = time
    }

    func updateTime() {
        currentSecond = Double(player.currentPlaybackTime)
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

    func setRepeat() {
        isRepeatOff = repeatMode == MusicPlayer.REPEAT_OFF
        isRepeatOne = repeatMode == MusicPlayer.REPEAT_ONE
        isRepeatAll = repeatMode == MusicPlayer.REPEAT_ALL
    }

    func changeRepeat() {
        if (isRepeatOff) {
            isRepeatOff = false
            isRepeatAll = true
        } else if (isRepeatAll) {
            isRepeatAll = false
            isRepeatOne = true
        } else if (isRepeatOne) {
            isRepeatOne = false
            isRepeatOff = true
        }
        repeatMode = repeatMode == MusicPlayer.REPEAT_OFF ? MusicPlayer.REPEAT_ALL
            : repeatMode == MusicPlayer.REPEAT_ALL ? MusicPlayer.REPEAT_ONE
            : MusicPlayer.REPEAT_OFF
        setRepeat()
        playerConfig.setRepeat(value: repeatMode)
    }

    func shuffle() {
        shuffleMode = !shuffleMode
        playingList.shuffle(shuffleMode: shuffleMode)
        playerConfig.setShuffle(shuffle: shuffleMode)
    }

    func setFavoriteArtist() {
        let favoriteArtistRegister = FavoriteArtistRegister()

        isFavoriteArtist = favoriteArtistRegister.exists(persistentId: song!.artistPersistentId!)
    }

    func favoriteArtist() {
        let persistentId = song!.artistPersistentId!
        let register = FavoriteArtistRegister()

        if (register.exists(persistentId: persistentId)) {
            register.delete(persistentId: persistentId)
        } else {
            register.add(persistentId: persistentId)
        }

        isFavoriteArtist = !isFavoriteArtist
    }

    func setFavoriteSong() {
        let register = FavoriteSongRegister()

        isFavoriteSong = register.exists(persistentId: song!.persistentId)
    }

    func favoriteSong() {
        let persistentId = song!.persistentId
        let register = FavoriteSongRegister()

        if (register.exists(persistentId: persistentId)) {
            register.delete(persistentId: persistentId)
        } else {
            register.add(persistentId: persistentId)
        }

        isFavoriteSong = !isFavoriteArtist
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main
        ) { notification in
            self.callback()
        }
    }

    // NotificationCenterのcallback
    // playbackStateが正しい状態でなかったり、pausedが複数回呼ばれるので、再生終了時の処理のみ登録
    private func callback() {
        // ユーザーが停止させた場合処理しない
        if (!isPlaying) {
            return
        }

        switch player.playbackState {
        case MPMusicPlaybackState.stopped:

            break
        case MPMusicPlaybackState.playing:
            playerState = MPMusicPlaybackState.playing

            break
        case MPMusicPlaybackState.paused:
            if (playerState == MPMusicPlaybackState.playing) {
                playerState = MPMusicPlaybackState.paused
                autoPlay()
            }
            break
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
}

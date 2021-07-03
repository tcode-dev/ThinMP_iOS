//
//  MusicPlayer.swift
//  ThinMP
//
//  Created by tk on 2020/01/31.
//

import MediaPlayer

class MusicPlayer: ObservableObject {
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
    private var timer: Timer?
    private var isBackground = false
    private var isFirst = false

    init() {
        playerConfig = PlayerConfig()
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = playerConfig.getRepeat()
        player.shuffleMode = playerConfig.getShuffle()
        setRepeat()
        setShuffle()
        player.beginGeneratingPlaybackNotifications()
    }

    func start(list:[SongModel], currentIndex: Int) {
        stop()
        song = SongModel(media: MPMediaItemCollection(items:[list[currentIndex].media.representativeItem! as MPMediaItem]))

        let items = MPMediaItemCollection(items: list.map{$0.media.representativeItem! as MPMediaItem})
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: items)
        descriptor.startItem = song?.media.representativeItem
        player.setQueue(with: descriptor)

        play();
        isActive = true
        setFavoriteArtist()
        setFavoriteSong()
        addObserver()
        isFirst = true
    }

    func doPlay() {
        play()
        startProgress()
    }

    func doPause() {
        pause()
        stopProgress()
    }

    func doPrev() {
        if (isPlaying) {
            playPrev()
        } else {
            prev()
        }
    }

    func doNext() {
        if (isPlaying) {
            playNext()
        } else {
            next()
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
        player.repeatMode = player.repeatMode == .none ? .all
            : player.repeatMode == .all ? .one
            : .none
        setRepeat()
        playerConfig.setRepeat(value: player.repeatMode)
    }

    func shuffle() {
        player.shuffleMode = player.shuffleMode == .off ? .songs : .off
        setShuffle();
        playerConfig.setShuffle(value: player.shuffleMode)
    }

    func favoriteArtist() {
        if let artistPersistentId = song?.artistPersistentId {
            let artistId = ArtistId(id: artistPersistentId)
            let register = FavoriteArtistRegister()

            if (register.exists(artistId: artistId)) {
                register.delete(artistId: artistId)
            } else {
                register.add(artistId: artistId)
            }

            isFavoriteArtist = !isFavoriteArtist
        }
    }

    func favoriteSong() {
        if let songId = song?.songId {
            let register = FavoriteSongRegister()

            if (register.exists(songId: songId)) {
                register.delete(songId: songId)
            } else {
                register.add(songId: songId)
            }
            isFavoriteSong = !isFavoriteSong
        }
    }

    private func setSong() {
        song = SongModel(media: MPMediaItemCollection(items:[player.nowPlayingItem! as MPMediaItem]))
        player.skipToBeginning()
        resetTime()
    }

    private func play() {
        isPlaying = true

        self.player.prepareToPlay()
        self.player.play()
    }

    private func pause() {
        isPlaying = false
        player.pause()
    }

    private func stop() {
        if (!isPlaying) {
            return
        }

        isPlaying = false
        player.stop()
    }

    private func prev() {
        stop()
        if (currentSecond <= PREV_SECOND) {
            player.skipToPreviousItem()
            setSong()
        } else {
            player.skipToBeginning()
            resetTime()
        }
    }

    private func playPrev() {
        prev()
        play()
    }

    private func next() {
        stop()
        player.skipToNextItem()
        setSong()
        resetTime()
    }

    private func playNext() {
        next()
        play()
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: player,
            queue: OperationQueue.main
        ) { notification in
            self.MPMusicPlayerControllerNowPlayingItemDidChangeCallback()
        }

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main
        ) { notification in
            self.MPMusicPlayerControllerPlaybackStateDidChangeCallback()
        }
    }

    private func MPMusicPlayerControllerPlaybackStateDidChangeCallback() {
        if (isPlaying && !isBackground) {
            return
        }

        switch player.playbackState {
        case MPMusicPlaybackState.stopped:

            break
        case MPMusicPlaybackState.playing:
            isPlaying = true

            break
        case MPMusicPlaybackState.paused:
            isPlaying = false

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

    private func MPMusicPlayerControllerNowPlayingItemDidChangeCallback() {
        setSong()

        if (player.repeatMode == .none && player.indexOfNowPlayingItem == 0 && !isFirst) {
            isPlaying = false
        }
        isFirst = false
    }

    private func setFavoriteArtist() {
        if let artistPersistentID = song?.artistPersistentId {
            let favoriteArtistRegister = FavoriteArtistRegister()

            isFavoriteArtist = favoriteArtistRegister.exists(artistId: ArtistId(id: artistPersistentID))
        }
    }

    private func setFavoriteSong() {
        if let songId = song?.songId {
            let register = FavoriteSongRegister()

            isFavoriteSong = register.exists(songId: songId)
        }
    }

    private func resetTime() {
        durationSecond = Double(song?.media.representativeItem?.playbackDuration ?? 0)
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
}

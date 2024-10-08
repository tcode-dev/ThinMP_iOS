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
        if (player.playbackState == MPMusicPlaybackState.playing) {
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

    private func setSong() {
        if player.nowPlayingItem != nil {
            song = SongModel(media: MPMediaItemCollection(items: [player.nowPlayingItem! as MPMediaItem]))
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
    }

    private func playbackStateDidChangeCallback() {
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

    deinit {
        removeObserver()

        player.endGeneratingPlaybackNotifications()
     }
}

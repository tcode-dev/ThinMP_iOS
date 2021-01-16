//
//  MusicPlayer.swift
//  ThinMP
//
//  Created by tk on 2020/01/31.
//

import MediaPlayer

class MusicPlayer: ObservableObject {
    @Published var isActive: Bool = false
    @Published var isPlaying: Bool = false
    @Published var song: MPMediaItemCollection?
    @Published var currentSecond: Double = 0
    @Published var durationSecond: Double = 0
    @Published var isRepeatOff: Bool = true
    @Published var isRepeatOne: Bool = false
    @Published var isRepeatAll: Bool = false

    static let REPEAT_OFF: Int = 0
    static let REPEAT_ONE: Int = 1
    static let REPEAT_ALL: Int = 2

    private var playerState: MPMusicPlaybackState = MPMusicPlaybackState.stopped
    private var repeatValue: Int
    private let playerConfig: PlayerConfig = PlayerConfig()

    private let PREV_SECOND: Double = 3

    private var timer: Timer?
    private var player: MPMusicPlayerController
    private var playingList: PlayingList = PlayingList(list: [], currentIndex: 0)

    init() {
        self.player = MPMusicPlayerController.applicationMusicPlayer
        self.player.repeatMode = .none
        self.repeatValue = self.playerConfig.getRepeat()
        self.setRepeat()
        self.addObserver()
        self.player.beginGeneratingPlaybackNotifications()
    }

    func start(list:[MPMediaItemCollection], currentIndex: Int) {
        self.playingList = PlayingList(list: list, currentIndex: currentIndex)

        self.stop()
        self.setSong()
        self.play();

        self.isActive = true
    }

    func setSong() {
        self.song = playingList.getSong()
        self.durationSecond = Double(self.song?.representativeItem?.playbackDuration ?? 0)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: self.song!)

        self.player.setQueue(with: descriptor)
        self.seek(time: 0)
        self.updateTime()
    }

    func play() {
        self.isPlaying = true
        self.player.play()
    }

    func pause() {
        self.isPlaying = false
        self.player.pause()
    }

    func stop() {
        if (!self.isPlaying) {
            return
        }

        self.isPlaying = false
        self.player.stop()
    }

    func prev() {
        self.stop()
        if (self.currentSecond <= self.PREV_SECOND) {
            self.playingList.prev()
            self.setSong()
        } else {
            self.seek(time: 0)
            self.updateTime()
        }
    }

    func playPrev() {
        self.isPlaying = false
        self.prev()
        self.play()
    }

    func next() {
        self.stop()
        self.playingList.next()
        self.setSong()
    }

    func playNext() {
        self.next()
        self.play()
    }

    func autoPlay() {
        if (self.isRepeatAll) {
            self.playNext()
        } else if (self.isRepeatOff) {
            if (self.playingList.hasNext()) {
                self.playNext()
            } else {
                self.next()
            }
        } else if (self.isRepeatOne) {
            self.setSong()
            self.play()
        }
    }

    func seek(time: TimeInterval) {
        self.player.currentPlaybackTime = time
    }

    func updateTime() {
        self.currentSecond = Double(self.player.currentPlaybackTime)
    }

    func immediateUpdateTime() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { _ in
            self.updateTime()
        })
    }

    func startProgress() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateTime()
        })
    }

    func stopProgress() {
        self.timer?.invalidate()
    }

    /**
     * setRepeat
     */
    func setRepeat() {
        self.isRepeatOff = self.repeatValue == MusicPlayer.self.REPEAT_OFF
        self.isRepeatOne = self.repeatValue == MusicPlayer.REPEAT_ONE
        self.isRepeatAll = self.repeatValue == MusicPlayer.REPEAT_ALL
    }

    func changeRepeat() {
        if (self.isRepeatOff) {
            self.isRepeatOff = false
            self.isRepeatAll = true
        } else if (self.isRepeatAll) {
            self.isRepeatAll = false
            self.isRepeatOne = true
        } else if (self.isRepeatOne) {
            self.isRepeatOne = false
            self.isRepeatOff = true
        }
        self.repeatValue = self.repeatValue == MusicPlayer.REPEAT_OFF ? MusicPlayer.REPEAT_ALL
            : self.repeatValue == MusicPlayer.REPEAT_ALL ? MusicPlayer.REPEAT_ONE
            : MusicPlayer.REPEAT_OFF
        self.setRepeat()
        self.playerConfig.setRepeat(value: self.repeatValue)
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
        if (!self.isPlaying) {
            return
        }

        switch self.player.playbackState {
        case MPMusicPlaybackState.stopped:

            break
        case MPMusicPlaybackState.playing:
            self.playerState = MPMusicPlaybackState.playing

            break
        case MPMusicPlaybackState.paused:
            if (self.playerState == MPMusicPlaybackState.playing) {
                self.playerState = MPMusicPlaybackState.paused
                self.autoPlay()
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

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
    @Published var playable: Bool = false
    @Published var song: MPMediaItemCollection?
    @Published var currentSecond: Double = 0
    @Published var currentTime: String = "0:00"
    @Published var durationSecond: Double = 0
    @Published var durationTime: String = "0:00"

    var timer: Timer?
    private var player: MPMusicPlayerController
    private var playingList: PlayingList = PlayingList(list: [], currentIndex: 0)
    
    init() {
        self.player = MPMusicPlayerController.applicationMusicPlayer
        self.player.repeatMode = .none
        self.addObserver()
        self.player.beginGeneratingPlaybackNotifications()
    }
    
    func start(list:[MPMediaItemCollection], currentIndex: Int) {
        self.playingList = PlayingList(list: list, currentIndex: currentIndex)
        
        self.stop()
        self.setSong()
        self.playPrepare()
        self.play();
        
        self.isActive = true
    }
    
    func setSong() {
        self.song = playingList.getSong()
        self.durationSecond = Double(self.song?.representativeItem?.playbackDuration ?? 0)
        self.durationTime = self.convertTime(time: self.song?.representativeItem?.playbackDuration ?? 0)
        self.currentSecond = 0
        self.currentTime = "0:00"
        self.playable = false
    }
    
    func playPrepare() {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: self.song!)
        
        self.player.setQueue(with: descriptor)
        self.playable = true
    }

    func play() {
        if (!self.playable) {
            self.playPrepare()
        }

        self.player.play()

        self.isPlaying = true
    }
    
    func pause() {
        self.isPlaying = false
        self.player.pause()
    }

    func stop() {
        self.isPlaying = false
        self.player.stop()
    }
    
    func prev() {
        self.playingList.prev()
        self.setSong()
    }

    func playPrev() {
        self.isPlaying = false
        self.prev()
        self.play()
    }

    func next() {
        self.playingList.next()
        self.setSong()
    }
    
    func playNext() {
        self.isPlaying = false
        self.next()
        self.play()
    }
    
    func autoPlay() {
        if (self.playingList.hasNext()) {
            self.playNext()
        }
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
    
    private func convertTime(time: TimeInterval) -> String {
        if (time < 1) {
            return "0:00"
        }

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute,.second]
        formatter.zeroFormattingBehavior = [.dropTrailing]

        return formatter.string(from: time) ?? "0:00"
    }
    
    func updateTime() {
        self.currentSecond = Double(self.player.currentPlaybackTime)
        self.currentTime = self.convertTime(time: self.player.currentPlaybackTime)
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
    
    private func callback() {
        switch self.player.playbackState {
        case MPMusicPlaybackState.stopped:
            NSLog("stopped")
            if (self.isPlaying) {
                self.autoPlay()
            }
            break
        case MPMusicPlaybackState.playing:
            NSLog("playing")
            break
        case MPMusicPlaybackState.paused:
            NSLog("paused")
            if (self.isPlaying) {
                self.autoPlay()
            }
            break
        case MPMusicPlaybackState.interrupted:
            NSLog("interrupted")
            break
        case MPMusicPlaybackState.seekingForward:
            NSLog("seekingForward")
            break
        case MPMusicPlaybackState.seekingBackward:
            NSLog("seekingBackward")
            break
        default:
            NSLog("default")
            break
        }
    }
}

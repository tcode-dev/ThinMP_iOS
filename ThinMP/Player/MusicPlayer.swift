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
    @Published var durationTime: String = "00:00"
    private let PREV_SECOND: Double = 3
    
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
        self.play();
        
        self.isActive = true
    }
    
    func setSong() {
        self.song = playingList.getSong()
        self.durationSecond = Double(self.song?.representativeItem?.playbackDuration ?? 0)
        self.durationTime = self.convertTime(time: self.song?.representativeItem?.playbackDuration ?? 0)
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: self.song!)
        
        self.player.setQueue(with: descriptor)
        self.seek(time: 0)
        self.updateTime()
    }
    
    func play() {
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
        self.isPlaying = false
        self.next()
        self.play()
    }
    
    func autoPlay() {
        if (self.playingList.hasNext()) {
            self.playNext()
        }
    }
    
    func seek(time: TimeInterval) {
        self.player.currentPlaybackTime = time
    }
    
    func convertTime(time: TimeInterval) -> String {
        if (time < 1) {
            return "00:00"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute,.second]
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: time) ?? "00:00"
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
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main
        ) { notification in
            self.callback()
        }
    }
    
    private func callback() {
        if (!self.isPlaying) {
            return
        }
        
        switch self.player.playbackState {
        case MPMusicPlaybackState.stopped:
            self.autoPlay()
            
            break
        case MPMusicPlaybackState.playing:
            
            break
        case MPMusicPlaybackState.paused:
            self.autoPlay()
            
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

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
    
    private var player: MPMusicPlayerController
    private var playingList: PlayingList = PlayingList(list: [], currentIndex: 0)
    
    init() {
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = .none
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }
    
    func start(list:[MPMediaItemCollection], currentIndex: Int) {
        playingList = PlayingList(list: list, currentIndex: currentIndex)
        
        self.setSong()
        self.play();
        
        self.isActive = true
    }
    
    func setSong() {
        self.song = playingList.getSong()
    }
    
    func play() {
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: self.song!)
        
        player.setQueue(with: descriptor)
        player.play()
        
        self.isPlaying = true
    }
    
    func stop() {
        self.isPlaying = false
        player.stop()
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

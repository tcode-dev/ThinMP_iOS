import MediaPlayer

class MusicService {
    var player: MPMusicPlayerController!
    
    func start(itemCollection: MPMediaItemCollection) {
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = .none
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: itemCollection)
        
        player.setQueue(with: descriptor)
        player.play()
        
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: player,
            queue: OperationQueue.main
        ) { notification in
            self.callback()
        }
    }
    
    func callback() {
        switch self.player!.playbackState {
        case MPMusicPlaybackState.stopped:
            NSLog("stopped")
            break
        case MPMusicPlaybackState.playing:
            NSLog("playing")
            break
        case MPMusicPlaybackState.paused:
            NSLog("paused")
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

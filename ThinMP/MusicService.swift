import MediaPlayer

class MusicService {
    var player: MPMusicPlayerController!
    func start(itemCollection: MPMediaItemCollection) {
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = .none
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: itemCollection)
        
        player.setQueue(with: descriptor)
        player.play()
        
        // 再生中のItemが変わった時に通知を受け取る
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(noti), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: player)
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
    }
    
    @objc func noti() {
        
        switch player!.playbackState {
        case MPMusicPlaybackState.stopped:
            NSLog("stopped")
            player.endGeneratingPlaybackNotifications()
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
        }
    }
}

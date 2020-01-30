import MediaPlayer

class MusicService {
    private var playingList: PlayingList?
    private static let instance: MusicService = {
        return MusicService()
    }()

    private var player: MPMusicPlayerController!
    
    private init() {
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = .none
        addObserver()
        player.beginGeneratingPlaybackNotifications()
    }

    class func sharedInstance() -> MusicService {
        return self.instance
    }

    func start(list:[MPMediaItemCollection], currentIndex: Int) {
        playingList = PlayingList(list: list, currentIndex: currentIndex)

        if let itemCollection = playingList?.getSong() {
            let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: itemCollection)
            
            player.setQueue(with: descriptor)
            player.play()
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
    
    func autoNext() {
        
    }
}

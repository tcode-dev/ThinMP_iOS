import MediaPlayer

class MusicService {
    private var player: MPMusicPlayerController
    private var playingList: PlayingList = PlayingList(list: [], currentIndex: 0)
    private var isPlaying: Bool = false
    private static let instance: MusicService = {
        return MusicService()
    }()
    
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
        
        self.play();
    }
    
    func play() {
        let itemCollection = playingList.getSong()
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: itemCollection)
        
        player.setQueue(with: descriptor)
        player.play()
        
        self.isPlaying = true
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
    
    func next() {
        
    }
    
    func autoPlay() {
        if (self.playingList.hasNext()) {
            self.playingList.next()
            self.play()
        }
    }
}

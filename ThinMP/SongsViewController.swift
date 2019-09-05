import UIKit
import MediaPlayer

class SongsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var player: MPMusicPlayerController!
    
    var songTitles:[String] = []
    var songItems:[MPMediaItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSongsAsync()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songTitles.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        cell.textLabel!.text = songTitles[indexPath.row]
        
        return cell
    }
    
    func setSongsAsync() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                self.songTitles = self.getSongs()
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getSongs() -> [String] {
        var songs:[String] = []
        let query = MPMediaQuery.songs()
        
        if let collections = query.collections {
            for collection in collections {
                if collection.representativeItem != nil, let representativeTitle = collection.representativeItem!.title {
                    self.songItems.append(collection.representativeItem!)
                    songs.append(representativeTitle)
                }
            }
        }
        
        return songs
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let item = songItems[indexPath.row]
        
        player = MPMusicPlayerController.applicationMusicPlayer
        //        player = MPMusicPlayerController.systemMusicPlayer
        player.repeatMode = .none
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(query: MPMediaQuery.songs())
        //        let list = MPMediaQuery.songs().collections
        //        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(MPMediaItemCollection: list)
        
        player.setQueue(with: descriptor)
        player.play()
    }
}

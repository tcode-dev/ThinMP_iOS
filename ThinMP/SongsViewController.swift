import UIKit
import MediaPlayer

class SongsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var player: MPMusicPlayerController!
    var songCollections:[MPMediaItemCollection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSongsAsync()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songCollections.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        cell.textLabel!.text = songCollections[indexPath.row].representativeItem!.title
        
        return cell
    }
    
    func setSongsAsync() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                self.songCollections = MPMediaQuery.songs().collections!
                
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player = MPMusicPlayerController.applicationMusicPlayer
        player.repeatMode = .none
        
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor.init(itemCollection: songCollections[indexPath.row])
        
        player.setQueue(with: descriptor)
        player.play()
    }
}

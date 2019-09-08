import UIKit
import MediaPlayer

class SongsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

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
        let musicService = MusicService()
        musicService.start(itemCollection: songCollections[indexPath.row])
    }
}

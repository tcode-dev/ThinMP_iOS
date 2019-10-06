import UIKit
import MediaPlayer

class SongsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    var songCollections:[MPMediaItemCollection] = []
    @IBOutlet var tableView: UITableView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewTrackCell", bundle: nil),forCellReuseIdentifier:"customTableViewTrackCell")
        setSongsAsync()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songCollections.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableViewTrackCell", for: indexPath) as! TableViewTrackCell
        
        if let item = songCollections[indexPath.row].representativeItem {
            // 曲名
            cell.primaryText.text = item.title
            
            // アーティスト名
            cell.secondaryText.text = item.artist
            
            // アートワーク
            cell.artworkView.image = nil
            if let artwork = item.artwork {
                cell.artworkView.contentMode = UIView.ContentMode.scaleAspectFill
                cell.artworkView.clipsToBounds = true
                cell.artworkView.image = artwork.image(at: cell.artworkView.bounds.size)
            }
        }
        
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
        let musicService = MusicService.sharedInstance()
        musicService.start(itemCollection: songCollections[indexPath.row])
    }
}

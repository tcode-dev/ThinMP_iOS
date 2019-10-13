import UIKit
import MediaPlayer

class AlbumDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arg: String!
    var songCollections:[MPMediaItemCollection] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var primaryText: UILabel!
    @IBOutlet var secondlyText: UILabel!
    @IBOutlet var artworkView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewTrackCell", bundle: nil),forCellReuseIdentifier:"customTableViewTrackCell")
        
        setUpWithPermissionCheck()
    }
    
    func setUpWithPermissionCheck() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            setUp()
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.setUp()
                }
            }
        }
    }
    
    func setUp() {
        let property = MPMediaPropertyPredicate(value: self.arg, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(property)
        let albums = query.items!.filter({$0.albumTitle != nil})
        songCollections = query.collections!

        if (albums.count) > 0 {
            let album = albums[0]
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.primaryText.text = album.albumTitle
                    self.secondlyText.text = album.albumArtist
                    
                    if let artwork = album.artwork {
                        self.artworkView.contentMode = UIView.ContentMode.scaleAspectFill
                        self.artworkView.clipsToBounds = true
                        self.artworkView.image = artwork.image(at: self.artworkView.bounds.size)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicService = MusicService.sharedInstance()
        musicService.start(itemCollection: songCollections[indexPath.row])
    }
}

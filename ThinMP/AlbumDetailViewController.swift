import UIKit
import MediaPlayer

class AlbumDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    var identifier: MPMediaEntityPersistentID!
    var songCollections:[MPMediaItemCollection] = []
//    var headerViewWidth: CGFloat!
//    var headerViewHeight: CGFloat!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var primaryText: UILabel!
    @IBOutlet var secondaryText: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewTrackCell", bundle: nil),forCellReuseIdentifier:"customTableViewTrackCell")
        
        setupWithPermissionCheck()
    }
    
    func setupWithPermissionCheck() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            setup()
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.setup()
                }
            }
        }
    }
    
    
    func setup() {
        let property = MPMediaPropertyPredicate(value: self.identifier, forProperty: MPMediaItemPropertyAlbumPersistentID)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(property)
        let albums = query.items!.filter({$0.albumTitle != nil})
        songCollections = query.collections!
        
        if (albums.count) > 0 {
            let album = albums[0]
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    
                    
                    if let artwork = album.artwork {
                        self.imageView.contentMode = UIView.ContentMode.scaleAspectFill
                        self.imageView.clipsToBounds = true
                        self.imageView.image = artwork.image(at: self.imageView.bounds.size)
                    }
                    self.primaryText.text = album.albumTitle
                    self.secondaryText.text = album.albumArtist
                    
                    self.tableView.reloadData()
                }
            }
        }
        
//        headerViewWidth = headerView.bounds.width
//        headerViewHeight = headerView.bounds.height
//        headerView.backgroundColor = UIColor.clear
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scroll = scrollView.contentOffset.y
//        if (scroll > 0 && scroll < headerViewHeight) {
//            pageView.frame = CGRect.init(x: 0, y: -scroll, width: headerViewWidth, height: headerViewHeight)
//        }
//    }
}

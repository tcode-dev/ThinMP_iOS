import UIKit
import MediaPlayer

class ArtistDetailViewController: UIViewController {
    var identifier: MPMediaEntityPersistentID!
    
    @IBOutlet var artworkView: UIImageView!
    @IBOutlet var primaryText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let property = MPMediaPropertyPredicate(value: self.identifier, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()
        query.addFilterPredicate(property)
        let songs = query.items!
        let albums = Dictionary.init(grouping: songs) { song -> MPMediaEntityPersistentID in
            return song.albumPersistentID
        }
//        albums.forEach { (album) in
//            let (albumPersistentID, mpMediaItems) = album
//            mpMediaItems.forEach({ (mpMediaItem) in
//                NSLog(mpMediaItem.title!)
//            })
//        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.primaryText.text = songs.first(where: { (song) -> Bool in
                    (song.artist != nil)
                })?.artist

                if let artwork = songs.first(where: { (song) -> Bool in
                    (song.artwork != nil)
                })?.artwork {
                    self.artworkView.contentMode = UIView.ContentMode.scaleAspectFill
                    self.artworkView.clipsToBounds = true
                    self.artworkView.image = artwork.image(at: self.artworkView.bounds.size)
                }

                //                    self.tableView.reloadData()
            }
        }
    }
}

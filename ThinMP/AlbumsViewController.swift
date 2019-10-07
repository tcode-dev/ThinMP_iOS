import UIKit
import MediaPlayer

class AlbumsViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var albumCollections:[MPMediaItemCollection] = []
    
    @IBOutlet var albumCollectionView: UICollectionView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollectionView.register(UINib(nibName: "CollectionViewAlubumCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewAlubumCell")
        
        setUpPermissionCheck()
    }
    
    func setUpPermissionCheck() {
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
        self.albumCollections = MPMediaQuery.albums().collections!
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.albumCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCollections.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewAlubumCell", for: indexPath) as! CollectionViewAlubumCell
        
        if let item = albumCollections[indexPath.row].representativeItem {
            if let albumTitle = item.albumTitle {
                cell.primaryText.text = albumTitle
            }
            
            if let artist = item.artist {
                cell.secondaryText.text = artist
            }
            
            cell.artworkView.image = nil
            if let artwork = item.artwork {
                cell.artworkView.contentMode = UIView.ContentMode.scaleAspectFill
                cell.artworkView.clipsToBounds = true
                cell.artworkView.image = artwork.image(at: cell.artworkView!.bounds.size)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "AlbumDetail") as! AlbumDetailViewController
        
        nextView.arg = String(albumCollections[indexPath.row].persistentID)
        
        self.present(nextView, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let horizontalSpace : CGFloat = 20
        let width : CGFloat = self.view.bounds.width / 2 - horizontalSpace
        let vertical : CGFloat = 50
        let height : CGFloat = width + vertical
        
        return CGSize(width: width, height: height)
    }
    
}

import UIKit
import MediaPlayer

class ArtistDetailViewController: UIViewController {
    var NUMBER_OF_SECTIONS = 2
    var identifier: MPMediaEntityPersistentID!
    var albums: [Album] = []
    var songs: [MPMediaItem] = []
    
    @IBOutlet var artworkView: UIImageView!
    @IBOutlet var primaryText: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CollectionViewAlubumCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewAlubumCell")
        collectionView.register(UINib(nibName: "CollectionViewTrackCell", bundle: nil),forCellWithReuseIdentifier:"customCollectionViewTrackCell")
        
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
        let property = MPMediaPropertyPredicate(value: self.identifier, forProperty: MPMediaItemPropertyArtistPersistentID)
        let query = MPMediaQuery.artists()
        query.addFilterPredicate(property)
        self.songs = query.items!
        let albumMap = Dictionary.init(grouping: songs) { song -> MPMediaEntityPersistentID in
            return song.albumPersistentID
        }
        
        albums = albumMap.map { (arg0) -> Album in
            let (persistentID, songs) = arg0
            let title = songs.first(where: { (song) -> Bool in
                (song.albumTitle != nil)
            })?.title
            let artist = songs.first(where: { (song) -> Bool in
                (song.albumArtist != nil)
            })?.artist
            let artwork = songs.first(where: { (song) -> Bool in
                (song.artwork != nil)
            })?.artwork
            
            return Album(persistentID: persistentID, title: title, artist: artist, artwork: artwork, songs: songs)
        }
        
        albums.sort(by: {$0.title! < $1.title! })
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.primaryText.text = self.albums.first(where: { (album) -> Bool in
                    (album.artist != nil)
                })?.artist
                
                if let artwork = self.albums.first(where: { (album) -> Bool in
                    (album.artwork != nil)
                })?.artwork {
                    self.artworkView.contentMode = UIView.ContentMode.scaleAspectFill
                    self.artworkView.clipsToBounds = true
                    self.artworkView.image = artwork.image(at: self.artworkView.bounds.size)
                }
            }
        }
    }
}

extension ArtistDetailViewController : UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return albums.count
        } else {
            return songs.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section == 0) {
            let album = albums[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewAlubumCell", for: indexPath) as! CollectionViewAlubumCell
            cell.primaryText.text = (album.title ?? "")
            cell.secondaryText.text = (album.artist ?? "")
            cell.artworkView.image = album.artwork != nil ? album.artwork!.image(at: cell.artworkView!.bounds.size) : nil
            
            return cell
        } else {
            let song = songs[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewTrackCell", for: indexPath) as! CollectionViewTrackCell
            cell.primaryText.text = (song.title ?? "")
            cell.secondaryText.text = (song.artist ?? "")
            cell.imageView.image = song.artwork != nil ? song.artwork!.image(at: cell.imageView!.bounds.size) : nil
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "AlbumDetail") as! AlbumDetailViewController
        
        nextView.identifier = albums[indexPath.row].persistentID
        
        self.present(nextView, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath.section == 0) {
            let horizontalSpace : CGFloat = 10
            let width : CGFloat = self.view.bounds.width / 2 - horizontalSpace
            let vertical : CGFloat = 42
            let height : CGFloat = width + vertical
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: self.view.bounds.width, height: 42)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return NUMBER_OF_SECTIONS
    }
}

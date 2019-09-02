import UIKit
import MediaPlayer

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    var albums:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAlbumsAsync()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        
        cell.textLabel!.text = albums[indexPath.row]
        
        return cell
    }
    
    func setAlbumsAsync() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                self.albums = self.getAlbums()
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getAlbums() -> [String] {
        var albums:[String] = []
        let query = MPMediaQuery.albums()
        if let collections = query.collections {
            for collection in collections {
                if let representativeTitle = collection.representativeItem!.albumTitle {
                    albums.append(representativeTitle)
                }
            }
        }
        
        return albums
    }}

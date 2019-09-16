import UIKit
import MediaPlayer

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    var albumCollections:[MPMediaItemCollection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAlbumsAsync()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumCollections.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
        
        cell.textLabel!.text = albumCollections[indexPath.row].representativeItem!.albumTitle
        
        return cell
    }
    
    func setAlbumsAsync() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                self.albumCollections = MPMediaQuery.albums().collections!
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = self.storyboard!
        
        let nextView = storyboard.instantiateViewController(withIdentifier: "AlbumDetail") as! AlbumDetailViewController
        
        nextView.arg = String(albumCollections[indexPath.row].persistentID)

        self.present(nextView, animated: true, completion: nil)
    }
}

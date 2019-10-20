import UIKit
import MediaPlayer

class ArtistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var artistCollections:[MPMediaItemCollection] = []
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
        let property = MPMediaPropertyPredicate(value: false, forProperty: MPMediaItemPropertyIsCloudItem)
        let query = MPMediaQuery.artists()
        query.addFilterPredicate(property)
        
        artistCollections = query.collections!
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistCollections.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)
        
        if let item = artistCollections[indexPath.row].representativeItem {
            if let artist = item.artist {
                cell.textLabel!.text = artist
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "ArtistDetail") as! ArtistDetailViewController
        
        nextView.arg = String(artistCollections[indexPath.row].persistentID)

        self.present(nextView, animated: true, completion: nil)
    }
}

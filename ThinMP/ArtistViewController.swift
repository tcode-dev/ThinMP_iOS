import UIKit
import MediaPlayer

class ArtistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
        @IBOutlet var tableView: UITableView!
    var artists:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setArtistsAsync()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)

        cell.textLabel!.text = artists[indexPath.row]
        
        return cell
    }

    func setArtistsAsync() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                self.artists = self.getArtists()
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func getArtists() -> [String] {
        var artists:[String] = []
        let query = MPMediaQuery.artists()

        if let collections = query.collections {
            for collection in collections {
                if let representativeTitle = collection.representativeItem!.artist {
                    artists.append(representativeTitle)
                }
            }
        }

        return artists
    }
}

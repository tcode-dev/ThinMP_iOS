import UIKit
import MediaPlayer

class SongsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var songs:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSongsAsync()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        cell.textLabel!.text = songs[indexPath.row]
        
        return cell
    }
    
    func setSongsAsync() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                self.songs = self.getSongs()
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getSongs() -> [String] {
        var songs:[String] = []
        let query = MPMediaQuery.songs()
        
        if let collections = query.collections {
            for collection in collections {
                if let representativeTitle = collection.representativeItem!.title {
                    songs.append(representativeTitle)
                }
            }
        }
        
        return songs
    }
}

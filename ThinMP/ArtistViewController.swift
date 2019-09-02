import UIKit
import MediaPlayer

class ArtistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        artists()
    }

    func artists() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                let query = MPMediaQuery.artists()
                if let collections = query.collections {
                    for collection in collections {
                        if let representativeTitle = collection.representativeItem!.artist {
                            print("アーティスト名: \(representativeTitle)  曲数: \(collection.items.count)")
                        }
                    }
                }
            }
        }
    }
}

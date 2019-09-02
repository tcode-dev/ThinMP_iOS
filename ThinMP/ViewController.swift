import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        albums()
        //        songs()
    }
    
    func albums() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {

            }
        }
    }
    
    func songs() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                let query = MPMediaQuery.songs()
                if let collections = query.collections {
                    for collection in collections {
                        if let representativeTitle = collection.representativeItem!.title {
                            print("曲名: \(representativeTitle)")
                        }
                    }
                }
            }
        }
    }
}

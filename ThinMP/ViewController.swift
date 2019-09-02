//
//  ViewController.swift
//  ThinMP
//
//  Created by tk on 2019/08/22.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        albums()
//        artists()
        songs()
    }

    func albums() {
        MPMediaLibrary.requestAuthorization { status in
            if status == .authorized {
                let query = MPMediaQuery.albums()
                if let collections = query.collections {
                    for collection in collections {
                        if let representativeTitle = collection.representativeItem!.albumTitle {
                            print("アルバム名: \(representativeTitle)  曲数: \(collection.items.count)")
                        }
                    }
                }
            }
        }
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

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
        albums()
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
}

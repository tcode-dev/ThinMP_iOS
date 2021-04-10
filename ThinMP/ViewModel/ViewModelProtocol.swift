//
//  BaseViewModel.swift
//  ThinMP
//
//  Created by tk on 2021/04/10.
//

import MediaPlayer

protocol ViewModelProtocol: ObservableObject {
    func fetch()
}

extension ViewModelProtocol {
    func load() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            fetch()
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    self.fetch()
                }
            }
        }
    }
}

//
//  MenuModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

struct MenuModel: MediaProtocol, Identifiable {
    var id = UUID()
    var primaryText: String?
    var visibility = true
}

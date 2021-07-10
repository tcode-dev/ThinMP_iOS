//
//  MenuModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MenuModel: Identifiable, ObservableObject {
    let id = UUID()
    let primaryText: String?
    @Published var visibility: Bool

    init(primaryText: String, visibility: Bool) {
        self.primaryText = primaryText
        self.visibility = visibility
    }

    func toggleVisibility() {
        visibility.toggle()
    }
}

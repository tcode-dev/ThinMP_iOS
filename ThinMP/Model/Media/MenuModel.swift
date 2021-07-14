//
//  MenuModel.swift
//  ThinMP
//
//  Created by tk on 2021/05/07.
//

import MediaPlayer

class MenuModel: Identifiable, ObservableObject {
    @Published var visibility: Bool

    let id = UUID()
    let primaryText: String

    init(primaryText: String, visibility: Bool) {
        self.primaryText = primaryText
        self.visibility = visibility
    }

    func toggleVisibility() {
        visibility.toggle()
    }
}

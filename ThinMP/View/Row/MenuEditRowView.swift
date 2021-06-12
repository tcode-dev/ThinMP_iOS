//
//  MenuEditRowView.swift
//  ThinMP
//
//  Created by tk on 2021/06/12.
//

import SwiftUI
import MediaPlayer

struct MenuEditRowView: View {
    private let size: CGFloat = 40
    
    @ObservedObject var menu: MenuModel
    
    init(menu: MenuModel) {
        self.menu = menu
    }
    
    var body: some View {
        HStack(alignment: .center) {
            CheckboxButton()
                .renderingMode(.original).resizable().frame(width: 24, height: 24)
                .frame(width: 36, height: 36)
            PrimaryTextView(menu.primaryText)
            Spacer()
        }
        .onTapGesture {
            menu.toggleVisibility()
        }
    }
    
    func CheckboxButton() -> Image {
        if (menu.visibility) {
            return Image("CheckboxOn")
        } else {
            return Image("CheckboxOff")
        }
    }
}

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
                .renderingMode(.original).resizable().frame(width: 30, height: 30)
                .frame(width: 44, height: 44)
                .onTapGesture {
                    menu.toggleVisibility()
                }
            PrimaryTextView(menu.primaryText)
                .frame(height: 44)
            Spacer()
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

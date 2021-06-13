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
        VStack {
            Spacer()
            HStack(alignment: .center) {
                CheckboxButton().renderingMode(.original)
                PrimaryTextView(menu.primaryText)
                Spacer()
            }
            .onTapGesture {
                menu.toggleVisibility()
            }
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

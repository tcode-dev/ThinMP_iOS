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
                Text(LocalizedStringKey(menu.primaryText!)).font(.body).foregroundColor(.primary).lineLimit(1)
                Spacer()
            }
            .onTapGesture {
                menu.toggleVisibility()
            }
            Spacer()
        }
    }

    private func CheckboxButton() -> Image {
        if menu.visibility {
            return Image("CheckboxOn")
        } else {
            return Image("CheckboxOff")
        }
    }
}

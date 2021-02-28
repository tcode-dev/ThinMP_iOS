//
//  FavoriteSongsNavBarView.swift
//  ThinMP
//
//  Created by tk on 2021/02/23.
//

import SwiftUI
import MediaPlayer

struct FavoriteSongsNavBarView: View {
    let primaryText: String = "FavoriteSongs"
    let heigt: CGFloat = 50

    var top: CGFloat

    @Binding var rect: CGRect

    var body: some View {
        ZStack {
            self.createHeaderView()
            HStack {
                BackButtonView()
                Spacer()
                PrimaryTextView(self.primaryText)
                Spacer()
                FavoriteSongsMenuButtonView()
            }
            .frame(height: heigt)
            .padding(EdgeInsets(
                top: top,
                leading: 0,
                bottom: 0,
                trailing: 0
            ))
        }
        .frame(height: heigt + top, alignment: .bottom)
        .zIndex(1)
    }

    private func createHeaderView() -> some View {
        return HStack(alignment: .center) {
            Spacer()
        }
        .frame(height: heigt)
        .padding(.top, top)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .opacity(self.opacity())
        .animation(.easeInOut)
    }

    private func opacity() -> Double {
        if (rect.origin.y >= 0) {
            return 0
        }

        return 1
    }
}

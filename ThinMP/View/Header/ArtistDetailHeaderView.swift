//
//  ArtistDetailHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

struct ArtistDetailHeaderView: View {
    @ObservedObject var vm: ArtistDetailViewModel
    @Binding var textRect: CGRect

    var side: CGFloat
    var top: CGFloat
    
    let artistImageSize:CGFloat = 120
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: self.vm.artwork?.image(at: CGSize(width: self.side, height: self.side)) ?? UIImage())
                .resizable()
                .scaledToFit()
                .blur(radius: 10.0)
            LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom).frame(height: 355).offset(y: 25)
            CircleImageView(artwork: self.vm.artwork, size: self.artistImageSize)
                .offset(y:-100)
            GeometryReader { primaryTextGeometry in
                self.createPrimaryTextView(primaryTextGeometry: primaryTextGeometry)
            }
            .frame(height: StyleConstant.height.row)
            .offset(y: -30)
            self.createSecondaryTextView()
        }
        .frame(height: side)
    }

    /// アーティスト名のViewを生成する
    /// ScrollViewの現在位置を取得する方法がないため、親が子のgeometryを参照できるようにする
    /// GeometryReader直下で変数を代入すると構文エラーになるので別メソッドにしている
    private func createPrimaryTextView(primaryTextGeometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.textRect = primaryTextGeometry.frame(in: .global)
        }

        return VStack {
            SecondaryTitleView(self.vm.primaryText).opacity(textOpacity())
        }
        .frame(width: side - 100, height: StyleConstant.height.row)
        .padding(.leading, StyleConstant.button)
        .padding(.trailing, StyleConstant.button)
    }

    private func createSecondaryTextView() -> some View {
        return VStack {
            SecondaryTextView(vm.secondaryText).opacity(textOpacity())
        }
        .frame(width: side - 100, height: 25, alignment: .center)
        .offset(y: -20)
        .animation(.easeInOut)
        .padding(.leading, StyleConstant.button)
        .padding(.trailing, StyleConstant.button)
    }

    private func textOpacity() -> Double {
        if (textRect.origin.y - self.top > 0) {
            return 1
        }

        return 0
    }
}

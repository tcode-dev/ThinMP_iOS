//
//  ArtistDetailHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

struct ArtistDetailHeaderView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    @Binding var textRect: CGRect

    var side: CGFloat
    var top: CGFloat
    var height: CGFloat = 50
    
    let artistImageSize:CGFloat = 120
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: self.artistDetail.artwork?.image(at: CGSize(width: self.side, height: self.side)) ?? UIImage())
                .resizable()
                .scaledToFit()
                .blur(radius: 10.0)
            LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom).frame(height: 355).offset(y: 25)
            CircleImageView(artwork: self.artistDetail.artwork, size: self.artistImageSize)
                .offset(y:-100)
            GeometryReader { primaryTextGeometry in
                self.createPrimaryTextView(primaryTextGeometry: primaryTextGeometry)
            }
            .frame(height: height)
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
            SecondaryTitleView(self.artistDetail.name).opacity(textOpacity())
        }
        .frame(width: side - 100, height: height)
        .padding(.leading, 50)
        .padding(.trailing, 50)
    }

    private func createSecondaryTextView() -> some View {
        return VStack {
            SecondaryTextView(self.artistDetail.meta).opacity(textOpacity())
        }
        .frame(width: side - 100, height: 25, alignment: .center)
        .offset(y: -20)
        .animation(.easeInOut)
        .padding(.leading, 50)
        .padding(.trailing, 50)
    }

    private func textOpacity() -> Double {
        if (textRect.origin.y - self.top > 0) {
            return 1
        }

        return 0
    }
}

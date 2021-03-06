//
//  AlbumDetailHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/17.
//

import SwiftUI

struct AlbumDetailHeaderView: View {
    @ObservedObject var albumDetail: AlbumDetailViewModel
    @Binding var textRect: CGRect
    
    var side: CGFloat
    var top: CGFloat
    var height: CGFloat = 50
    var padding: CGFloat = 50
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: self.albumDetail.artwork?.image(at: CGSize(width: self.side, height: self.side)) ?? UIImage())
                .resizable()
                .scaledToFit()
            LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), Color(UIColor.systemBackground)]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
            GeometryReader { primaryTextGeometry in
                self.createPrimaryTextView(primaryTextGeometry: primaryTextGeometry)
            }
            .frame(height: 50)
            .offset(y: -30)
            self.createSecondaryTextView()
        }
        .frame(width: side, height: side)
    }
    
    /// アルバム名のViewを生成する
    /// ScrollViewの現在位置を取得する方法がないため、親が子のgeometryを参照できるようにする
    /// GeometryReader直下で変数を代入すると構文エラーになるので別メソッドにしている
    private func createPrimaryTextView(primaryTextGeometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.textRect = primaryTextGeometry.frame(in: .global)
        }
        
        return VStack {
            SecondaryTitleView(self.albumDetail.title).opacity(textOpacity())
        }
        .frame(width: side - (padding + padding), height: height)
        .padding(.leading, padding)
        .padding(.trailing, padding)
    }
    
    private func createSecondaryTextView() -> some View {
        return VStack {
            SecondaryTextView(self.albumDetail.artist).opacity(textOpacity())
        }
        .frame(width: side - 100, height: 25, alignment: .center)
        .offset(y: -20)
        .animation(.easeInOut)
        .padding(.leading, padding)
        .padding(.trailing, padding)
    }
    
    private func textOpacity() -> Double {
        if (textRect.origin.y - self.top > 0) {
            return 1
        }
        
        return 0
    }
}

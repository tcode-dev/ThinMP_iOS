//
//  AlbumDetailHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/17.
//

import SwiftUI

struct AlbumDetailHeaderView: View {
    @ObservedObject var albumDetail: AlbumDetailViewModel
    @Binding var rect: CGRect
    
    var side: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            self.createHeaderView(geometry: geometry)
        }
        .frame(width: side, height: side)
    }
    
    /// HeaderViewを生成する
    /// ScrollViewの現在位置を取得する方法がないため、子のgeometryを親から参照できるようにする
    /// GeometryReader直下で変数を代入すると構文エラーになるので別メソッドにしている
    /// - Parameter geometry: geometry
    fileprivate func createHeaderView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }
        
        return ZStack(alignment: .bottom) {
            Image(uiImage: self.albumDetail.artwork?.image(at: CGSize(width: self.side, height: self.side)) ?? UIImage())
                .resizable()
                .scaledToFit()
            LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), .white]), startPoint: .top, endPoint: .bottom).frame(height: 200)
            VStack {
                PrimaryTextView(self.albumDetail.title)
                SecondaryTextView(self.albumDetail.artist)
            }
            .padding(.leading, 50)
            .padding(.trailing, 50)
        }
    }
}

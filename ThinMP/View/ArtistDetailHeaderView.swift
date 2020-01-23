//
//  ArtistDetailHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

struct ArtistDetailHeaderView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    @Binding var rect: CGRect
    var side: CGFloat
    
    let artistImageSize:CGFloat = 120
    
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
            Image(uiImage: self.artistDetail.artwork?.image(at: CGSize(width: geometry.size.width, height: geometry.size.width)) ?? UIImage())
                .resizable()
                .scaledToFill()
                .blur(radius: 10.0)
            
            LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), .white]), startPoint: .top, endPoint: .bottom).frame(height: 355).offset(y: 25)
            CircleImageView(artwork: self.artistDetail.artwork, size: self.artistImageSize)
                .offset(y:-100)
            
            VStack {
                PrimaryTextView(self.artistDetail.name)
                SecondaryTextView(self.artistDetail.meta)
            }
        }
    }
}

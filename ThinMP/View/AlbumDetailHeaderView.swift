//
//  AlbumDetailHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/17.
//

import SwiftUI

struct AlbumDetailHeaderView: View {
    @State private var offsetY: CGFloat = 0
    @ObservedObject var albumDetail: AlbumDetailViewModel
    
    private let width = UIScreen.main.bounds.size.width
    
    init(albumDetail: AlbumDetailViewModel) {
        self.albumDetail = albumDetail
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image(uiImage: self.albumDetail.artwork?.image(at: CGSize(width: self.width, height: self.width)) ?? UIImage())
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                LinearGradient(gradient: Gradient(colors: [Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0), .white]), startPoint: .top, endPoint: .bottom).frame(height: 200)
                VStack {
                    PrimaryTextView(self.albumDetail.title)
                    SecondaryTextView(self.albumDetail.artist)
                    PrimaryTextView("\(geometry.frame(in: .global).origin.y)")
                }
            }
        }.frame(width: width, height: width)
    }
}

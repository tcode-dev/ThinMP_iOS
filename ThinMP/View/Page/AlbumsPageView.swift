//
//  AlbumsPageView.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import SwiftUI

struct AlbumsPageView: View {
    @ObservedObject var albums = AlbumsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            AlbumsView(list: self.albums.list, width: geometry.size.width)
        }.navigationBarTitle("Albums")
    }
}

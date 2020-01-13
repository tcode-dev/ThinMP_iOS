//
//  AlbumsContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import SwiftUI

struct AlbumsContentView: View {
    @ObservedObject var albums = AlbumsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                AlbumsView(list: self.albums.list, width: geometry.size.width)
            }
        }
    }
}

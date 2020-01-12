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
        List(albums.list){ album in
            NavigationLink(destination: AlbumDetailContentView(album: album)) {
                AlbumRowView(album: album)
            }
        }
    }
}

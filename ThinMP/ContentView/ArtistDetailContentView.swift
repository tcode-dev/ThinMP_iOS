//
//  ArtistDetailContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailContentView: View {
    @ObservedObject var artistDetail: ArtistDetailViewModel
    init(artist: Artist) {
        self.artistDetail = ArtistDetailViewModel(persistentId: artist.persistentId)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                AlbumsView(list: self.artistDetail.albums, width: geometry.size.width)
                ArtistSongsView(list: self.artistDetail.songs)
            }
        }
    }
}

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
        Text(artistDetail.name!)
    }
}

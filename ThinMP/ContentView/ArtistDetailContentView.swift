//
//  ArtistDetailContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/07.
//

import SwiftUI

struct ArtistDetailContentView: View {
    @ObservedObject var artistDetail: ArtistDetail
    init(artist: Artist) {
        self.artistDetail = ArtistDetail(persistentId: artist.persistentId)
    }

    var body: some View {
        Text(artistDetail.name!)
    }
}

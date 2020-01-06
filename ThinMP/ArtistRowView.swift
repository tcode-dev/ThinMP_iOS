//
//  ArtistRowView.swift
//  ThinMP
//
//  Created by tk on 2020/01/06.
//

import SwiftUI

struct ArtistRowView: View {
    var artist: Artist

    var body: some View {
        Text(artist.name)
    }
}

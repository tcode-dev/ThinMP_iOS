//
//  ArtistsContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsContentView: View {
    @ObservedObject var artists = ArtistsViewModel()
    
    var body: some View {
        List(artists.list){ artist in
            NavigationLink(destination: ArtistDetailContentView(artist: artist)) {
                ArtistRowView(artist: artist)
            }
        }
    }
}

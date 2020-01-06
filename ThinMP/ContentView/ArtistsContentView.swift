//
//  ArtistsContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/05.
//

import SwiftUI

struct ArtistsContentView: View {
    @ObservedObject var artists = Artists()
    
    var body: some View {
        List{
            ForEach(artists.list.indices) { index in
                ArtistRowView(artist: self.artists.list[index])
            }
        }
    }
}

struct ArtistsContentView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsContentView()
    }
}

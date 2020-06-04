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
        VStack {
            HStack {
                Text(artist.name ?? "unknown")
                Spacer()
            }
            Divider()
        }
    }
}

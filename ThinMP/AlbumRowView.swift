//
//  AlbumView.swift
//  ThinMP
//
//  Created by tk on 2020/01/12.
//

import SwiftUI

struct AlbumRowView: View {
    var album: Album

    var body: some View {
        Text(album.title ?? "unknown")
    }
}

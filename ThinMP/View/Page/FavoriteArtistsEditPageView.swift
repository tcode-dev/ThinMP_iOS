//
//  FavoriteArtistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsEditPageView: View {
    @State private var vm = FavoriteArtistsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.artists != nil, onDone: vm.save) {
            List {
                if let artists = Binding($vm.artists) {
                    ReorderableListView(items: artists) { artist in
                        PlainRowView(media: artist)
                    }
                }
            }
        }
        .task {
            await vm.load()
        }
    }
}

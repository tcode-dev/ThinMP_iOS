//
//  FavoriteArtistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/01/10.
//

import SwiftUI

struct FavoriteArtistsEditPageView: View {
    @StateObject private var vm = FavoriteArtistsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ReorderableListView(items: $vm.artists) { artist in
                    PlainRowView(media: artist)
                }
            }
        }
        .onAppear {
            vm.load()
        }
    }
}

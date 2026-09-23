//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @StateObject private var vm = FavoriteSongsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ReorderableListView(items: $vm.songs) { song in
                    MediaRowView(media: song)
                }
            }
        }
        .onAppear {
            vm.load()
        }
    }
}

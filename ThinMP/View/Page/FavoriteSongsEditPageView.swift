//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @State private var vm = FavoriteSongsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.songs != nil, onDone: vm.save) {
            List {
                if let songs = Binding($vm.songs) {
                    ReorderableListView(items: songs) { song in
                        MediaRowView(media: song)
                    }
                }
            }
        }
        .onAppear {
            vm.load()
        }
    }
}

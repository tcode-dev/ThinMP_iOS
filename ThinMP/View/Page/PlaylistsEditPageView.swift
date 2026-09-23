//
//  PlaylistsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/04/24.
//

import SwiftUI

struct PlaylistsEditPageView: View {
    @StateObject private var vm = PlaylistsViewModel()

    var body: some View {
        EditPageLayout(isDoneEnabled: vm.playlists != nil, onDone: vm.save) {
            List {
                if let playlists = Binding($vm.playlists) {
                    ReorderableListView(items: playlists) { playlist in
                        MediaRowView(media: playlist, showsSecondaryText: false)
                    }
                }
            }
        }
        .onAppear {
            vm.load()
        }
    }
}

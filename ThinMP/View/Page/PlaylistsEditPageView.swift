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
        EditPageLayout(isDoneEnabled: vm.isLoaded, onDone: vm.save) {
            List {
                ReorderableListView(items: $vm.playlists) { playlist in
                    MediaRowView(media: playlist)
                }
            }
        }
        .onAppear {
            vm.load()
        }
    }
}

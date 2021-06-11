//
//  MainEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/06/08.
//

import SwiftUI

struct MainEditPageView: View {
    private let ARTISTS: String = "Artists"
    private let ALBUMS: String = "Albums"
    private let SONGS: String = "Songs"
    private let FAVORITE_ARTISTS: String = "Favorite Artists"
    private let FAVORITE_SONGS: String = "Favorite Songs"
    private let PLAYLISTS: String = "Playlists"

    private let RECENTLY_ADDED: String = "Recently Added"
    private let SHORTCUTS: String = "Shortcuts"

    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation

    @ObservedObject public var vm: MainViewModel
    // データコレクションの準備
    @State private var list = [
        MenuModel(primaryText: "Artists"),
        MenuModel(primaryText: "Albums"),
        MenuModel(primaryText: "Songs"),
        MenuModel(primaryText: "Favorite Artists"),
        MenuModel(primaryText: "Favorite Songs"),
        MenuModel(primaryText: "Playlists")
    ]
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            back()
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                        Button(action: {
                            update()
                            back()
                        }) {
                            Text("Done")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                VStack(alignment: .leading) {
                    List {
                        ForEach (list) { menu in
                            MediaRowView(media: menu)
                        }
                        .onMove(perform: move)
                    }

                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
        }
    }
    func move(source: IndexSet, destination: Int) {
        //        vm.songs.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        //        vm.songs.remove(atOffsets: offsets)
    }

    func update() {

    }

    func back() {
        presentation.wrappedValue.dismiss()
    }
}

//
//  FavoriteSongsEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/02/28.
//

import SwiftUI

struct FavoriteSongsEditPageView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation

    @ObservedObject public var vm: FavoriteSongsViewModel
    
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
                        ForEach (vm.list, id: \.id) { media in
                            MediaRowView(media: media)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
        }
    }

    func move(source: IndexSet, destination: Int) {
        vm.list.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        vm.list.remove(atOffsets: offsets)
    }

    func update() {
        let favoriteSongRegister = FavoriteSongRegister()

        favoriteSongRegister.update(persistentIdList:vm.list.map{$0.persistentId})
    }

    func back() {
        presentation.wrappedValue.dismiss()
    }
}
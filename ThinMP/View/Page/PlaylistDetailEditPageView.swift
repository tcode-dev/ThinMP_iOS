//
//  PlaylistDetailEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import SwiftUI

struct PlaylistDetailEditPageView: View {
    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation
    @StateObject private var vm = PlaylistDetailViewModel()
    @State private var name: String = ""
    @State private var editing: Bool = false

    let playlistId: PlaylistId
    let primaryText: String?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EditNavBarView(top: geometry.safeAreaInsets.top) {
                    HStack {
                        Button(action: {
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                        Button(action: {
                            update()
                            presentation.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                    .padding(.horizontal, StyleConstant.Padding.large)
                }
                .modifier(EditModifier(editing: editing))
                VStack(alignment: .leading) {
                    TextField("", text: $name, onEditingChanged: { begin in
                        editing = begin
                    })
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onAppear {
                            name = primaryText ?? ""
                        }
                    ZStack {
                        List {
                            ForEach(vm.songs, id: \.id) { media in
                                MediaRowView(media: media)
                            }
                            .onMove(perform: move)
                            .onDelete(perform: delete)
                            .listRowInsets(.init())
                        }
                        if editing {
                            VStack {
                                Rectangle().fill(Color.white.opacity(0.5))
                            }
                            .onTapGesture { UIApplication.shared.endEditing() }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                vm.load(playlistId: playlistId)
            }
        }
    }

    private func move(source: IndexSet, destination: Int) {
        vm.songs.move(fromOffsets: source, toOffset: destination)
    }

    private func delete(offsets: IndexSet) {
        vm.songs.remove(atOffsets: offsets)
    }

    private func update() {
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(playlistId: vm.playlistId, name: name, songIds: vm.songs.map { $0.songId })

        vm.primaryText = name
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EditModifier: ViewModifier {
    let editing: Bool

    func body(content: Content) -> some View {
        if editing {
            content.onTapGesture { UIApplication.shared.endEditing() }
        } else {
            content
        }
    }
}

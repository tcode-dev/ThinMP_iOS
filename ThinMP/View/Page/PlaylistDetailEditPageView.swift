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

    @ObservedObject public var vm: PlaylistDetailViewModel

    @State private var name: String = ""
    @State private var editing: Bool = false

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
                    .padding(.horizontal, 20)
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
                        name = vm.name ?? ""
                    }
                    ZStack {
                        List {
                            ForEach (vm.list, id: \.id) { media in
                                MediaRowView(media: media)
                            }
                            .onMove(perform: move)
                            .onDelete(perform: delete)
                        }
                        if (editing) {
                            VStack {
                                Rectangle().fill(Color.white.opacity(0.5))
                            }
                            .onTapGesture {UIApplication.shared.endEditing()}
                        }
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
        let playlistRegister = PlaylistRegister()

        playlistRegister.update(playlistId: vm.playlistId, name: name, persistentIds: vm.list.map{$0.persistentId})

        vm.name = name
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
        if (editing) {
            content.onTapGesture {UIApplication.shared.endEditing()}
        } else {
            content
        }
    }
}

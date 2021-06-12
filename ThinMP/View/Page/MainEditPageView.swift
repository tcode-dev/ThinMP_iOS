//
//  MainEditPageView.swift
//  ThinMP
//
//  Created by tk on 2021/06/08.
//

import SwiftUI

struct MainEditPageView: View {
    private let RECENTLY_ADDED: String = "Recently Added"
    private let SHORTCUTS: String = "Shortcuts"

    @Environment(\.editMode) var editMode
    @Environment(\.presentationMode) var presentation

    @StateObject private var vm = MainViewModel()

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
                        ForEach (vm.menus, id: \.id) { menu in
                            MediaRowView(media: menu)
                        }
                        .onMove(perform: moveMenu)
                    }

                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text(""))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                vm.load()
            }
        }
    }

    func moveMenu(source: IndexSet, destination: Int) {
        vm.menus.move(fromOffsets: source, toOffset: destination)
    }

    func delete(offsets: IndexSet) {
        //        vm.songs.remove(atOffsets: offsets)
    }

    func update() {
        let mainMenuConfig = MainMenuConfig()
        let menus = vm.menus.map {$0.primaryText!}

        mainMenuConfig.setSort(value: menus)
    }

    func back() {
        presentation.wrappedValue.dismiss()
    }
}

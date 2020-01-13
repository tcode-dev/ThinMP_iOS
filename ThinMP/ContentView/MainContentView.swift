//
//  MainContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/04.
//

import SwiftUI

struct MainContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ArtistsContentView()) {
                    Text("Artists")
                }
                NavigationLink(destination: AlbumsContentView()) {
                    Text("Albums")
                }
                NavigationLink(destination: SongsContentView()) {
                    Text("Songs")
                }
            }
            .navigationBarTitle("Library")
        }
    }
}

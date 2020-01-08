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
            NavigationLink(destination: ArtistsContentView()) {
                Text("Artists")
            }
        }
    }
}

//
//  AlbumsContentView.swift
//  ThinMP
//
//  Created by tk on 2020/01/10.
//

import SwiftUI

struct AlbumsContentView: View {
    @ObservedObject var albums = AlbumsViewModel()
    
    var body: some View {
        ScrollView{
            AlbumsView(list: albums.list)
        }
    }
}

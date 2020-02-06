//
//  AlbumRowView.swift
//  ThinMP
//
//  Created by tk on 2020/02/06.
//

import SwiftUI
import MediaPlayer

struct AlbumRowView: View {
    var list: [Album]
    var size: CGFloat
    var space: CGFloat
    @State var isActive: Bool = false
    @State var persistentId: MPMediaEntityPersistentID = 0
    
    var body: some View {
        HStack(spacing: self.space) {
            ForEach(list.indices) { col in
                AlbumCellView(album: self.list[col], size: self.size)
                    .onTapGesture {
                        self.isActive = true
                        self.persistentId = self.list[col].persistentID
                }
            }
            NavigationLink.init(destination: AlbumDetailPageView(persistentId: self.persistentId), isActive: self.$isActive) {
                EmptyView()
            }
        }
    }
}

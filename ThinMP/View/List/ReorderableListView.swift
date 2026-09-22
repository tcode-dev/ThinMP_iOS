//
//  ReorderableListView.swift
//  ThinMP
//
//  Created by tk on 2026/09/23.
//

import SwiftUI

/// 編集ページの、並び替えと削除ができる行の集まり
/// List の中に置く。メインの編集ページのように他の行と並べることもある
struct ReorderableListView<Item: Identifiable, Row: View>: View {
    /// 並び替えと削除はこの配列に直接反映する。保存は編集ページの完了が ViewModel に任せる
    @Binding var items: [Item]
    @ViewBuilder let row: (Item) -> Row

    var body: some View {
        ForEach(items) { item in
            row(item)
        }
        .onMove { source, destination in
            items.move(fromOffsets: source, toOffset: destination)
        }
        .onDelete { offsets in
            items.remove(atOffsets: offsets)
        }
        .listRowInsets(.init())
    }
}

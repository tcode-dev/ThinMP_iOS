//
//  ListEmptyHeaderView.swift
//  ThinMP
//
//  Created by tk on 2021/01/25.
//

import SwiftUI

struct ListEmptyHeaderView: View {
    @Binding var headerRect: CGRect

    let top: CGFloat

    var body: some View {
        ZStack {
            GeometryReader { gometry in
                createEmptyView(gometry: gometry)
            }
        }
        .frame(height: StyleConstant.Height.row + top)
    }

    private func createEmptyView(gometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            headerRect = gometry.frame(in: .global)
        }

        return HStack {
            Text("")
        }
        .frame(height: StyleConstant.Height.row + top)
    }
}

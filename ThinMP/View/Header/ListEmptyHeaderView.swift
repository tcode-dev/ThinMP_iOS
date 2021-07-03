//
//  ListEmptyHeaderView.swift
//  ThinMP
//
//  Created by tk on 2021/01/25.
//

import SwiftUI

struct ListEmptyHeaderView: View {
    @Binding var headerRect: CGRect

    var top: CGFloat

    var body: some View {
        ZStack {
            GeometryReader { gometry in
                self.createEmptyView(gometry: gometry)
            }
        }
        .frame(height: StyleConstant.height.row + top)
    }

    private func createEmptyView(gometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.headerRect = gometry.frame(in: .global)
        }

        return HStack() {
            Text("")
        }.frame(height: StyleConstant.height.row + top)
    }
}

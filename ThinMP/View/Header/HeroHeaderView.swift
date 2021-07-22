//
//  HeroHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

struct HeroHeaderView<Content>: View where Content: View {
    @Binding var headerRect: CGRect

    let side: CGFloat
    let top: CGFloat
    let primaryText: String?
    let secondaryText: String?
    let content: () -> Content

    var body: some View {
        ZStack(alignment: .bottom) {
            content()
            GeometryReader { primaryTextGeometry in
                createPrimaryTextView(primaryTextGeometry: primaryTextGeometry)
            }
            .frame(height: StyleConstant.Height.row)
            .offset(y: -40)
            SecondaryTextView(secondaryText)
                .frame(width: abs(side - (StyleConstant.button * 2)), height: 25, alignment: .center)
                .offset(y: -30)
                .padding(.leading, StyleConstant.button)
                .padding(.trailing, StyleConstant.button)
        }
        .frame(height: side)
    }

    /// PrimaryTextのViewを生成する
    /// ScrollViewの現在位置を取得する方法がないため、親が子のgeometryを参照できるようにする
    /// GeometryReader直下で変数を代入すると構文エラーになるので別メソッドにしている
    private func createPrimaryTextView(primaryTextGeometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            headerRect = primaryTextGeometry.frame(in: .global)
        }

        return VStack {
            TitleView(primaryText).opacity(textOpacity())
        }
        .frame(width: abs(side - (StyleConstant.button * 2)), height: StyleConstant.Height.row)
        .padding(.leading, StyleConstant.button)
        .padding(.trailing, StyleConstant.button)
    }

    private func textOpacity() -> Double {
        if headerRect.origin.y - top > 0 {
            return 1
        }

        return 0
    }
}

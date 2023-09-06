//
//  HeroHeaderView.swift
//  ThinMP
//
//  Created by tk on 2020/01/23.
//

import SwiftUI

struct HeroHeaderView<Content>: View where Content: View {
    @Binding var headerRect: CGRect

    let width: CGFloat
    let height: CGFloat
    let top: CGFloat
    let bottom: CGFloat
    let primaryText: String?
    let secondaryText: String?
    let content: () -> Content

    let isLandscape = UIDevice.current.orientation.isLandscape

    var body: some View {
        let size = isLandscape ? height + top + bottom : width

        ZStack(alignment: .bottom) {
            content()
            GeometryReader { geometry in
                createPrimaryTextView(geometry: geometry)
            }
            .frame(height: StyleConstant.Height.row)
            .offset(y: -40)
            SecondaryTextView(secondaryText)
                .frame(width: abs(width - (StyleConstant.button * 2)), height: 25, alignment: .center)
                .offset(y: -30)
                .padding(.leading, StyleConstant.button)
                .padding(.trailing, StyleConstant.button)
        }
        .frame(height: size)
    }

    /// PrimaryTextのViewを生成する
    /// ScrollViewの現在位置を取得する方法がないため、親が子のgeometryを参照できるようにする
    /// GeometryReader直下で変数を代入すると構文エラーになるので別メソッドにしている
    private func createPrimaryTextView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            headerRect = geometry.frame(in: .global)
        }

        return VStack {
            TitleView(primaryText).opacity(textOpacity())
        }
        .frame(width: abs(width - (StyleConstant.button * 2)), height: StyleConstant.Height.row)
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

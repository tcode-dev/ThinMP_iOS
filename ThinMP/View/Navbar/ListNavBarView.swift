//
//  ListNavBarView.swift
//  ThinMP
//
//  Created by tk on 2020/06/01.
//

import SwiftUI

/// 一覧ページのナビゲーションバー。戻るボタンとタイトルを持ち、一覧がスクロールで潜り込んだら背景を出す
struct ListNavBarView<Trailing: View>: View {
    let title: String
    let top: CGFloat
    /// 一覧側の `ListEmptyHeaderView` の位置。ここが上端より上に行ったら背景を出す
    @Binding var headerRect: CGRect
    /// 右端に置くボタン。戻るボタンと同じ幅に揃えてタイトルを中央に保つ
    let trailing: () -> Trailing

    init(title: String, top: CGFloat, headerRect: Binding<CGRect>, @ViewBuilder trailing: @escaping () -> Trailing) {
        self.title = title
        self.top = top
        _headerRect = headerRect
        self.trailing = trailing
    }

    var body: some View {
        ZStack {
            createHeaderView()
            HStack {
                BackButtonView()
                Spacer()
                HeaderTitleView(title)
                Spacer()
                trailing()
                    .frame(width: StyleConstant.button, height: StyleConstant.button)
            }
            .frame(height: StyleConstant.Height.row)
            .padding(.top, top)
        }
        .frame(height: StyleConstant.Height.row + top, alignment: .bottom)
        .zIndex(1)
    }

    private func createHeaderView() -> some View {
        return HStack(alignment: .center) {
            Spacer()
        }
        .frame(height: StyleConstant.Height.row)
        .padding(.top, top)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .opacity(opacity())
        .animation(.easeInOut, value: opacity())
    }

    private func opacity() -> Double {
        // ListEmptyHeaderView の高さがセーフエリアの分を含んでいるので、基準は画面の上端
        return headerRect.isScrolledUnder(top: 0) ? 1 : 0
    }
}

extension ListNavBarView where Trailing == Color {
    /// 右端に置くものがないページ用。戻るボタン分の空きだけ確保する
    init(title: String, top: CGFloat, headerRect: Binding<CGRect>) {
        self.init(title: title, top: top, headerRect: headerRect) { Color.clear }
    }
}

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
    /// 一覧側の `ListEmptyHeaderView` が上端より上に行ったか。行ったら背景を出す
    let isScrolledUnder: Bool
    /// 右端に置くボタン。戻るボタンと同じ幅に揃えてタイトルを中央に保つ
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        ZStack {
            headerView
            HStack {
                BackButtonView()
                Spacer()
                TitleView(key: title)
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

    /// 一覧が潜り込んだときだけ出るナビゲーションバーの背景
    private var headerView: some View {
        return Color.clear
            .frame(height: StyleConstant.Height.row)
            .padding(.top, top)
            .background(Color(UIColor.secondarySystemBackground))
            .border(Color(UIColor.systemGray5), width: 1)
            .opacity(opacity)
            .animation(.easeInOut, value: opacity)
    }

    private var opacity: Double {
        return isScrolledUnder ? 1 : 0
    }
}

extension ListNavBarView where Trailing == Color {
    /// 右端に置くものがないページ用。戻るボタン分の空きだけ確保する
    init(title: String, top: CGFloat, isScrolledUnder: Bool) {
        self.init(title: title, top: top, isScrolledUnder: isScrolledUnder) { Color.clear }
    }
}

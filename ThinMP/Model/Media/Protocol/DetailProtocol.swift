//
//  DetailProtocol.swift
//  ThinMP
//
//  Created by tk on 2021/06/01.
//

/// 詳細ページのモデル。id はショートカットの itemId と同じ文字列
protocol DetailProtocol: MediaProtocol {
    var id: String { get }
}

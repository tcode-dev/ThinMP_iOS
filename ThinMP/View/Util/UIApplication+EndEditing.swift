//
//  UIApplication+EndEditing.swift
//  ThinMP
//
//  Created by tk on 2021/05/04.
//

import UIKit

extension UIApplication {
    /// フォーカス中の入力欄からフォーカスを外してキーボードを閉じる
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

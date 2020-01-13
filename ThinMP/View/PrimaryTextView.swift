//
//  PrimaryTextView.swift
//  ThinMP
//
//  Created by tk on 2020/01/13.
//

import SwiftUI

struct PrimaryTextView: View {
    var text: String
    init(_ text: String?) {
        self.text = text ?? "unknown"
    }

    var body: some View {
        Text(text).font(.body).foregroundColor(.primary).lineLimit(1)
    }
}

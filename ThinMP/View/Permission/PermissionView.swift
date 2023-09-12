//
//  PermissionView.swift
//  ThinMP
//
//  Created by tk on 2023/09/11.
//

import SwiftUI

struct PermissionView<Content>: View where Content: View {
    let content: () -> Content

    var body: some View {
        content()
    }
}

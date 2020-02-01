//
//  BackButtonView.swift
//  ThinMP
//
//  Created by tk on 2020/01/24.
//

import SwiftUI

struct BackButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image("BackButton").renderingMode(.original)
        }
        .frame(width: 50, height: 50)
    }
}

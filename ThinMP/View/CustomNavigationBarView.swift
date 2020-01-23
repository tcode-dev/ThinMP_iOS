//
//  CustomNavigationBarView.swift
//  ThinMP
//
//  Created by tk on 2020/01/19.
//

import SwiftUI

struct CustomNavigationBarView: View {
    var primaryText: String?
    var secondaryText: String?
    var side: CGFloat
    
    @Binding var rect: CGRect
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack() {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("<")
                }
                Spacer()
                VStack {
                    PrimaryTextView(self.primaryText)
                    SecondaryTextView(self.secondaryText)
                }
                .frame(height: 50, alignment: .center)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("<")
                }
            }
        }
        .frame(width: side, height: 95, alignment: .bottomLeading)
        .background(Color.white)
        .opacity(self.opacity())
        .zIndex(1)
        .edgesIgnoringSafeArea(.all)
    }
    
    func opacity() -> Double {
        if (-rect.origin.y < (side - 70)) {
            return 0
        }
        
        return 0.97
    }
}

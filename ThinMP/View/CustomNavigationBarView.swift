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
    
    var body: some View {
        VStack {
            HStack() {
                VStack {
                    PrimaryTextView(self.primaryText)
                    SecondaryTextView(self.secondaryText)
                }
                .frame(width: side, height: 50, alignment: .center)
            }
        }
        .frame(width: side, height: 95, alignment: .bottomLeading)
        .background(Color.white)
        .opacity(self.opacity())
    }
    
    func opacity() -> Double {
        if (-rect.origin.y < (side - 70)) {
            return 0
        }
        
        return 0.97
    }
}

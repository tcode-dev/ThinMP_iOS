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
        HStack {
            VStack {
                PrimaryTextView(self.primaryText)
                SecondaryTextView(self.secondaryText)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .topLeading)
        .background(Color.white)
        .opacity(self.opacity())
    }
    
    func opacity() -> Double {
        if (-rect.origin.y < (side - 65)) {
            return 0
        }
        
        return 0.97
    }
}

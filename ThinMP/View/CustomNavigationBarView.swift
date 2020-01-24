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
        ZStack {
            HStack {
                BackButtonView()
                Spacer()
                MenuButtonView()
            }
            .frame(width: side, height: 90, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
            .zIndex(3)
            VStack {
                VStack {
                    PrimaryTextView(self.primaryText)
                    SecondaryTextView(self.secondaryText)
                }
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .frame(height: 50, alignment: .center)
            }
            .frame(width: side, height: 90, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
            .background(Color.white)
            .opacity(self.opacity())
            .zIndex(2)
        }
        .frame(width: side, height: 90, alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .zIndex(1)
    }
    
    func opacity() -> Double {
        if (-rect.origin.y < (side - 65)) {
            return 0
        }
        
        return 0.97
    }
}

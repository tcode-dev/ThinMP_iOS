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
    
    @Binding var pageRect: CGRect
    @State var headerRect: CGRect!
    
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
                GeometryReader { geometry in
                    self.createHeaderView(geometry: geometry)
                }
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
    
    fileprivate func createHeaderView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.headerRect = geometry.frame(in: .global)
        }
        
        return ZStack {
            VStack {
                PrimaryTextView(self.primaryText)
                SecondaryTextView(self.secondaryText)
            }
            .frame(height: 50, alignment: .center)
            .offset(y: -geometry.frame(in: .global).origin.y)
        }
        .padding(.init(top: 0, leading: 50, bottom: 0, trailing: 50))
    }
    
    fileprivate func opacity() -> Double {
        if (headerRect == nil) {
            return 0
        }
        
        if (pageRect.origin.y > -headerRect.origin.y) {
            return 0
        }
        
        return 0.97
    }
}

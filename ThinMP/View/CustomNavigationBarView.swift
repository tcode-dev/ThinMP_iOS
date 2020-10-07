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
    let heigt: CGFloat = 50
    let statusBarHeight: CGFloat = 20
    
    @Binding var pageRect: CGRect
    @Binding var headerRect: CGRect
    
    var body: some View {
        ZStack {
            HStack() {
                BackButtonView()
                Spacer()
                MenuButtonView()
            }
            .frame(height: heigt)
            .zIndex(3)
            VStack {
                GeometryReader { geometry in
                    self.createHeaderView(geometry: geometry)
                }
            }
            .frame(height: heigt + statusBarHeight)
            .background(Color.white)
            .opacity(self.opacity())
            .zIndex(2)
        }
        .frame(width: side, height: heigt + statusBarHeight, alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .zIndex(1)
    }
    
    fileprivate func createHeaderView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.headerRect = geometry.frame(in: .global)
        }
        
        return ZStack {
            HStack {
                Spacer()
                PrimaryTextView(self.primaryText)
                Spacer()
            }
            .frame(height: heigt, alignment: .center)
            .padding(.top, statusBarHeight)
        }
    }
    
    fileprivate func opacity() -> Double {
        if (pageRect.origin.y - self.statusBarHeight > -headerRect.origin.y) {
            return 0
        }
        
        return 0.97
    }
}

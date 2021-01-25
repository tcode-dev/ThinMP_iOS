//
//  CustomNavigationBarView.swift
//  ThinMP
//
//  Created by tk on 2020/01/19.
//

import SwiftUI
import MediaPlayer

struct CustomNavigationBarView: View {
    var persistentId: MPMediaEntityPersistentID
    var primaryText: String?
    var secondaryText: String?
    var side: CGFloat
    var top: CGFloat
    let heigt: CGFloat = 50
    
    @Binding var textRect: CGRect
    
    var body: some View {
        ZStack {
            HStack() {
                BackButtonView()
                Spacer()
                MenuButtonView(persistentId: persistentId, primaryText: primaryText)
            }
            .frame(height: heigt)
            .padding(EdgeInsets(
                top: top,
                leading: 0,
                bottom: 0,
                trailing: 0
            ))
            .zIndex(3)
            self.createHeaderView()
            self.createTitleView()
                .zIndex(2)
        }
        .frame(height: heigt + top)
        .zIndex(1)
    }
    
    private func createHeaderView() -> some View {
        return HStack(alignment: .center) {
        }
        .frame(width: side, height: heigt)
        .padding(.top, top)
        .background(Color(UIColor.secondarySystemBackground))
        .border(Color(UIColor.systemGray5), width: 1)
        .opacity(self.opacity())
        .animation(.easeInOut)
    }
    
    private func createTitleView() -> some View {
        return HStack(alignment: .center) {
            PrimaryTextView(self.primaryText)
        }
        .frame(width: side - 100, height: heigt)
        .padding(EdgeInsets(
            top: top,
            leading: 50,
            bottom: 0,
            trailing: 50
        ))
        .opacity(self.opacity())
    }
    
    private func opacity() -> Double {
        if (textRect.origin.y - self.top > 0) {
            return 0
        }
        
        return 1
    }
}

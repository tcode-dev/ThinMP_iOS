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
    
    @Binding var pageRect: CGRect
    @Binding var headerRect: CGRect
    
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
            GeometryReader { geometry in
                self.createHeaderView(geometry: geometry)
            }
            .zIndex(2)
        }
        .frame(height: heigt + top)
        .zIndex(1)
    }
    
    fileprivate func createHeaderView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.headerRect = geometry.frame(in: .global)
        }
        
        return HStack(alignment: .center) {
            Spacer()
            PrimaryTextView(self.primaryText)
            Spacer()
        }
        .frame(height: heigt)
        .padding(EdgeInsets(
            top: top,
            leading: 50,
            bottom: 0,
            trailing: 50
        ))
        .background(Color(UIColor.secondarySystemBackground))
        .opacity(self.opacity())
    }
    
    fileprivate func opacity() -> Double {
        if (pageRect.origin.y - self.top > -headerRect.origin.y) {
            return 0
        }
        
        return 1
    }
}

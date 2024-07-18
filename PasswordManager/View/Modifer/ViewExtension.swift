//
//  hideListRowSeperator.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import SwiftUI

extension View {
    func hideListRowSeperator(color: Color) -> some View {
        if #available(iOS 15, *) {
            return AnyView(self.listRowSeparator(.hidden))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            
        }
        else {
            return AnyView(self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .listRowInsets(EdgeInsets(top: -1, leading: -1, bottom: -1, trailing: -1))
                .listRowBackground(Color.clear)
                .background(Color.clear))
        }
    }
    
    @ViewBuilder //hide Indicator in List
    func hideIndicator() -> some View {
        if #available(iOS 16, *) {
            self.modifier(Ios16_HideIndicator())
        } else {
            self.modifier(Ios15_HideIndicator())
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // design for Notification Banner
    func notificationBanner<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        overlay(
            content()
                .onTapGesture { withAnimation {
                    isPresented.wrappedValue = false
                }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let direction = value.detectDirection(25)
                            switch direction {
                            case .up:
                                print("Swiped left")
                                withAnimation {
                                    isPresented.wrappedValue = false
                                }
                            default:
                                return
                            }
                        }
                )
                .opacity(isPresented.wrappedValue ? 1 : 0)
                .offset(y: isPresented.wrappedValue ? 0 : -135)
                .animation(Animation.easeInOut, value: isPresented.wrappedValue)
            , alignment: .top)
    }
}

extension DragGesture.Value {
    func detectDirection(_ tolerance: Double = 24) -> Direction? {
        if startLocation.x < location.x - tolerance { return .left }
        if startLocation.x > location.x + tolerance { return .right }
        if startLocation.y > location.y + tolerance { return .up }
        if startLocation.y < location.y - tolerance { return .down }
        return nil
    }
    
    enum Direction {
        case left
        case right
        case up
        case down
    }
}


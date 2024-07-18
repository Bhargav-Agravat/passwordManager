//
//  PullToRefresh.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import Foundation
import SwiftUI

struct PullToRefresh: ViewModifier {
    var action: () -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .refreshable {
                    Task {
                        action()
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func pullToRefresh(action: @escaping () -> Void) -> some View {
        self.modifier(PullToRefresh(action: action))
    }
}



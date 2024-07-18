//
//  HideIndicator.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import SwiftUI

@available(iOS 16, *)
struct Ios16_HideIndicator: ViewModifier {
    
    func body(content: Content) -> some View {
        content.scrollIndicators(.hidden)
    }
}


struct Ios15_HideIndicator: ViewModifier {
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    func body(content: Content) -> some View {
        content
    }
}

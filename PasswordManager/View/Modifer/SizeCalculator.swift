//
//  SizeCalculator.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import SwiftUI

struct SizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                size = proxy.size
                            }
                        }
                }
            )
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}

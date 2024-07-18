//
//  HudSceneView.swift
//  DemoForBannerAlerts
//
//  Created by Bhargav Agravat on 18/07/24.
//

import SwiftUI

struct BannerAlertsSceneView: View {
    @StateObject var hudState = BannerAlertsViewModel.shared
  var body: some View {
    Color.clear
      .ignoresSafeArea(.all)
      .notificationBanner(isPresented: $hudState.isPresentedAlert) {
          HStack{
              Image(systemName: hudState.alertType == .failed ? "xmark" : "checkmark")
                  .font(.system(size: 21))
                  .foregroundColor(Color.white)
              
              Text(hudState.alertMsg)
                  .font(.system(size: 21))
                  .foregroundColor(Color.white)
                  .minimumScaleFactor(0.5)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .frame(height: 75)
          .background(hudState.alertType == .failed ? Color.red.ignoresSafeArea(.all) : Color.green.ignoresSafeArea(.all))
          .animation(Animation.easeInOut, value: hudState.isPresentedAlert)
          .onChange(of: hudState.isPresentedAlert) { value in
              guard value else { return } // if `value` is not `true` then return
              DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                  hudState.isPresentedAlert = false
              }
          }
      }
  }
}

//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import SwiftUI

@main
struct PasswordManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var bannerNotiViewModel = BannerAlertsViewModel()
    @StateObject var appLockVM = AppLockViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bannerNotiViewModel)
                .environmentObject(appLockVM)

        }
    }
}

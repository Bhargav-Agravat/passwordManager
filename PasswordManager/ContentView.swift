//
//  ContentView.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    @EnvironmentObject var bannerAlertsViewModel: BannerAlertsViewModel
    @EnvironmentObject var appLockVM: AppLockViewModel
    
    @State var blurRadius: CGFloat = 0
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage(UserDefaultsKeys.isAppLockEnabled.rawValue) private var isAppLockEnabled = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                if !appLockVM.isAppLockEnabled || appLockVM.isAppUnlocked{
                    HomeView()
                        .preferredColorScheme(.light)
                        .blur(radius: blurRadius)
                        .onChange(of: scenePhase, perform: { value in
                            switch value{
                            case .active:
                                blurRadius = 0
                            case .background:
                                print("App in background")
                            case .inactive:
                                if isAppLockEnabled{
                                    blurRadius = 5
                                }
                                else{
                                    blurRadius = 0
                                }
                            @unknown default:
                                print("unknown")
                            }
                        })
                        .onAppear(){
                            sceneDelegate.bannerNotificationHubState = bannerAlertsViewModel
                        }
                }
                else{
                    Color.clear
                        .frame(width: geometry.size.width , height: geometry.size.height, alignment: .center)
                }
            }
            .onAppear{
                if appLockVM.isAppLockEnabled{
                    appLockVM.appLockValidation()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

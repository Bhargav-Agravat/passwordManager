//
//  SceneDelegate.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import SwiftUI

final class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    var bannerNotificationHubState = BannerAlertsViewModel.shared {
        didSet {
            setupHudWindow()
        }
    }
    
    var toastWindow: UIWindow?
    weak var windowScene: UIWindowScene?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        windowScene = scene as? UIWindowScene
    }
    
    // banner type alerts
    func setupHudWindow() {
        guard let windowScene = windowScene else {
            return
        }
        
        let toastViewController = UIHostingController(rootView: BannerAlertsSceneView())
        toastViewController.view.backgroundColor = .clear
        
        let toastWindow = PassThroughWindow(windowScene: windowScene)
        toastWindow.rootViewController = toastViewController
        toastWindow.isHidden = false
        self.toastWindow = toastWindow
    }
}

//
//  HudState.swift
//  DemoForBannerAlerts
//
//  Created by Bhargav Agravat on 18/07/24.
//

import Combine

enum bannerAlertType{
    case success
    case failed
}

final class BannerAlertsViewModel: ObservableObject {
    static let shared: BannerAlertsViewModel = BannerAlertsViewModel()
    
    @Published var isPresentedAlert: Bool = false
    private(set) var alertMsg: String = ""
    private(set) var alertType: bannerAlertType = .success
    
    func show(title: String, alertType: bannerAlertType) {
        self.alertMsg = title
        self.alertType = alertType
        self.isPresentedAlert = true
    }
}

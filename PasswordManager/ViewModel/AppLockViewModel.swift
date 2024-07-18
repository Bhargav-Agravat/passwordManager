//
//  AppLockViewModel.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import Foundation
import LocalAuthentication
import SwiftUI

class AppLockViewModel: ObservableObject {
    static let shared = AppLockViewModel()
    @Published var isAppLockEnabled: Bool = false
    @Published var isAppUnlocked:Bool = false
    
    init() {
        getAppLockState()
    }
    func enableAppLock() {
        UserDefaults.standard.set(true,forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = true
    }
    func disableAppLock() {
        UserDefaults.standard.set(false,forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
        self.isAppLockEnabled = false
    }
    func getAppLockState() {
        self.isAppLockEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
    }
    
    func checkIfBioMetricAvailable() -> Bool {
        var error:NSError?
        let laContext = LAContext()
        let isBiometricAvailable = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error{
            print(error.localizedDescription)
        }
        return isBiometricAvailable
    }
    
    func appLockStateChange(appLockState:Bool, isUseFaceID: Bool) {
        let laContext = LAContext()
        if isUseFaceID {
            let reason = "Authenticate using your faceID"
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ (success,error) in
                if success{
                    if appLockState{
                        DispatchQueue.main.async {
                            self.enableAppLock()
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.disableAppLock()
                        }
                    }
                }
                else if (error as NSError?)?.code == Int(kLAErrorUserFallback) {
                    let passcodePolicy: LAPolicy = .deviceOwnerAuthentication
                    // Biometric fallback to passcode authentication
                    laContext.evaluatePolicy(passcodePolicy, localizedReason: reason) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                if appLockState {
                                    self.enableAppLock()
                                } else {
                                    self.disableAppLock()
                                }
                            }
                        } else if let error = error {
                            DispatchQueue.main.async {
                                print(error.localizedDescription)
                                self.getAppLockState()
                            }
                        }
                    }
                }
                else{
                    if let error = error{
                        DispatchQueue.main.async { [self] in
                            print(error.localizedDescription)
                            getAppLockState()
                        }
                    }
                }
            }
        }
        else{
            let reason = "Authenticate using your finger or passcode"
            
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason){ (success,error) in
                if success{
                    if appLockState{
                        DispatchQueue.main.async {
                            self.enableAppLock()
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.disableAppLock()
                        }
                    }
                }
                else{
                    if let error = error{
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                            self.getAppLockState()
                            //                            let alert = UIAlertController(title: localization.Key(key: .NotAvailableKey), message: localization.Key(key: .CantuseKey), preferredStyle: .alert)
                            //                            alert.addAction(UIAlertAction(title: localization.Key(key: .DismissKey), style: .cancel, handler: nil))
                            //                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: false, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func appLockValidation(){
        let laContext = LAContext()
        if checkIfBioMetricAvailable(){
            let reason = "Authenticate using your faceID"
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){(success, error) in
                if success{
                    DispatchQueue.main.async {
                        self.isAppUnlocked = true
                    }
                }
                else if (error as NSError?)?.code == Int(kLAErrorUserFallback) {
                    let passcodePolicy: LAPolicy = .deviceOwnerAuthentication
                    // Biometric fallback to passcode authentication
                    laContext.evaluatePolicy(passcodePolicy, localizedReason: reason) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.isAppUnlocked = true
                            }
                        } else if let error = error {
                            DispatchQueue.main.async {
                                print(error.localizedDescription)
                                self.appLockValidation()
                            }
                        }
                    }
                }
                else{
                    if let error = error{
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                            self.appLockValidation()
                        }
                    }
                }
            }
        }
        else{
            let reason = "Authenticate using your finger or passcode"
            laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason){ (success,error) in
                if success{
                    DispatchQueue.main.async {
                        self.isAppUnlocked = true
                    }
                }
                else{
                    if let error = error{
                        DispatchQueue.main.async {
                            print(error.localizedDescription)
                            //                            getAppLockState()
                            let alert = UIAlertController(title: "Not Available", message: "You can't use this feature", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: false, completion: nil)
                        }
                    }
                }
            }
        }
    }
}

enum UserDefaultsKeys:String {
    case isAppLockEnabled
}

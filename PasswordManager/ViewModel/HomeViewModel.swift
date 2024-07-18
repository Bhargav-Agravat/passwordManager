//
//  HomeViewModel.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import Foundation

class HomeViewModel: ObservableObject{
    @Published var txtAccountName: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    
    @Published var isOpenAddPasswordSheet: Bool = false
    @Published var isOpenDetailsSheet: Bool = false
    @Published var isOpenPasswordGenerateSheet: Bool = false
    @Published var isShowDeleteAlert: Bool = false
    @Published var isOpenSettingsView: Bool = false
    
    @Published var passwordListData: [PasswordModel] = []
    @Published var selectedPasswordData: PasswordModel?
    
    var dbManage = DbManager.shared
    let encryptor = AES.shared
    var encryptionKey = "!@#$789!@#BK*Agravat"
    
    //fetch data
    func fetchPasswordData(){
        passwordListData = dbManage.fetchPasswords()
    }
    
    func resetData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            txtAccountName = ""
            txtEmail = ""
            txtPassword = ""
        }
        
        fetchPasswordData()
        isOpenAddPasswordSheet = false
        isOpenDetailsSheet = false
        isOpenPasswordGenerateSheet = false
    }
    
    func txtValidate() -> Bool {
        guard !txtAccountName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print(strAccountValidationMsg)
            BannerAlertsViewModel.shared.show(title: strAccountValidationMsg, alertType: .failed)
            
            return false
        }
        
        guard !txtEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print(strEmailValidationMsg)
            BannerAlertsViewModel.shared.show(title: strEmailValidationMsg, alertType: .failed)
            
            return false
        }
        
        guard !txtPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print(strPasswordValidationMsg)
            BannerAlertsViewModel.shared.show(title: strPasswordValidationMsg, alertType: .failed)
            
            return false
        }
        
        return true
    }
    
    //insert database
    func inserNewPasswordData(){
        if txtValidate(){
            do {
                //encryption password
                let encryptedMessage = try encryptor.encryptMessage(message: txtPassword, encryptionKey: encryptionKey)
                let (success, errorMessage) = dbManage.insertPassword(accountType: txtAccountName, emailUsername: txtEmail, password: encryptedMessage, createdAt: Date())
                
                if success{
                    BannerAlertsViewModel.shared.show(title: strPasswordSave, alertType: .success)
                    resetData()
                }
                else if let error = errorMessage {
                    BannerAlertsViewModel.shared.show(title: error, alertType: .failed)
                    print("can't able to inser \((error))")
                }
            } catch {
                print("Error: \(error)")
                BannerAlertsViewModel.shared.show(title: error.localizedDescription, alertType: .failed)
                
            }
        }
    }
    
    //update database
    func updateNewPasswordData(){
        if txtValidate(){
            do {
                //encryption password
                let encryptedMessage = try encryptor.encryptMessage(message: txtPassword, encryptionKey: encryptionKey)
                let (success, errorMessage) = dbManage.updatePassword(id: selectedPasswordData?.id ?? 0, accountType: txtAccountName, emailUsername: txtEmail, password: encryptedMessage)
                if success {
                    resetData()
                    BannerAlertsViewModel.shared.show(title: strPasswordUpdate, alertType: .success)
                    print("up successfully.")
                } else if let error = errorMessage {
                    print("Failed toupda password: \(error)")
                    BannerAlertsViewModel.shared.show(title: error, alertType: .failed)
                    
                }
                
            } catch {
                print("Error: \(error)")
                BannerAlertsViewModel.shared.show(title: error.localizedDescription, alertType: .failed)
            }
        }
    }
    
    func decryptionPassword(encryptedMessage: String) -> String{
        do {
            let decryptedMessage = try encryptor.decryptMessage(encryptedMessage: encryptedMessage, encryptionKey: encryptionKey)
            return decryptedMessage
        } catch {
            print("Error: \(error)")
            BannerAlertsViewModel.shared.show(title: error.localizedDescription, alertType: .failed)
            return "Error"
        }
    }
    
    //delete from database
    func deletePasswordData(){
        let (success, errorMessage) = dbManage.deletePassword(id: selectedPasswordData?.id ?? 0)
        if success {
            resetData()
            
            BannerAlertsViewModel.shared.show(title: strPassworddelete, alertType: .success)
            
            print("delete successfully.")
        } else if let error = errorMessage {
            BannerAlertsViewModel.shared.show(title: error, alertType: .failed)
            print("Failed delete password: \(error)")
        }
    }
    
    func btnAddAction(){
        selectedPasswordData = nil
        txtAccountName = ""
        txtEmail = ""
        txtPassword = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isOpenAddPasswordSheet = true
        }
    }
    
    func btnEditAction(){
        txtAccountName = selectedPasswordData?.accountType ?? ""
        txtEmail = selectedPasswordData?.emailUsername ?? ""
        txtPassword = selectedPasswordData?.password ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isOpenAddPasswordSheet = true
        }
    }
    
    func btnDeleteAction(){
        isShowDeleteAlert = true
    }
    
    
}

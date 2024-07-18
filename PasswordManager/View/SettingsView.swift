//
//  SettingsView.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var appLockVM = AppLockViewModel.shared
    
    var body: some View {
        ZStack{
            Color.appBg
                .ignoresSafeArea(.all)
            
            VStack{
                topNav
                
                Toggle(isOn: $appLockVM.isAppLockEnabled, label: {
                    Text("Face ID & Passcode")
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.appBlue))
                .onChange(of: appLockVM.isAppLockEnabled, perform: { value in
                    let tmpValue = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAppLockEnabled.rawValue)
                    print("Old Value \(tmpValue) ==== New \(value)")
                    if tmpValue != value{
                        appLockVM.appLockStateChange(appLockState: value, isUseFaceID: appLockVM.checkIfBioMetricAvailable())
                    }
                })
                .padding()
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
    
    var topNav: some View{
        VStack(alignment: .leading, spacing: 0){
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color.appBlue)
                    
                    Text(strSettings)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.fontBlack)
                })
                .padding()
                
                Spacer()
            }
            Color.seprator
                .frame(height: 1)
        }
    }
}

#Preview {
    SettingsView()
}

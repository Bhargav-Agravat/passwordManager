//
//  AddPasswordSheetView.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import SwiftUI

struct AddPasswordSheetView: View {
    @StateObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 25){
            TextField(strAccountName, text: $homeViewModel.txtAccountName)
                .font(.system(size: 13, weight: .regular))
                .padding()
                .background(Color.white)
                .cornerRadius(6.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.txtBorder, lineWidth: 1)
                )
                .onTapGesture { // for no dissmiss keyboard
                }
            
            TextField(strUsernameEmail, text: $homeViewModel.txtEmail)
                .font(.system(size: 13, weight: .regular))
                .keyboardType(.emailAddress)
                .padding()
                .background(Color.white)
                .cornerRadius(6.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.txtBorder, lineWidth: 1)
                )
                .onTapGesture {
                }
            
            HStack{
                TextField(strPassword, text: $homeViewModel.txtPassword)
                    .font(.system(size: 13, weight: .regular))
                    .padding()
                    .background(Color.white)
                    .cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.txtBorder, lineWidth: 1)
                    )
                    .onTapGesture {
                    }
                
                Button(action: {
                    homeViewModel.isOpenPasswordGenerateSheet = true
                }, label: {
                    Text(strAuto)
                        .font(.system(size: 16, weight: .regular))
                        .padding(13)
                        .foregroundColor(Color.white)
                        .background(Color.appBlue.opacity(0.9))
                        .cornerRadius(6.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.txtBorder, lineWidth: 1)
                        )
                })
            }
            
            Button(action: {
                if homeViewModel.selectedPasswordData == nil{
                    homeViewModel.inserNewPasswordData()
                }
                else{
                    homeViewModel.updateNewPasswordData()
                }
            }, label: {
                Text(homeViewModel.selectedPasswordData == nil ? strAddNewAccount : strUpdateAccount)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(13)
                    .background(Color.btnBgBlack
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1))
                    .cornerRadius(20.0)
            })
            .padding(.top, 5)
            
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 7)
    }
}

#Preview {
    AddPasswordSheetView(homeViewModel: HomeViewModel())
}

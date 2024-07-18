//
//  DetailsViewSheet.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import SwiftUI

struct DetailsViewSheetView: View {
    @StateObject var homeViewModel: HomeViewModel
    @State var isShowPassword: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 25){
            Text(strAccountDetails)
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(Color.appBlue)
            
            VStack(alignment: .leading, spacing: 7){
                Text(strAccountType)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.fontTitleGray)
                
                Text(homeViewModel.selectedPasswordData?.accountType ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.fontBlack)
            }
            
            VStack(alignment: .leading, spacing: 7){
                Text(strUsernameEmail)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.fontTitleGray)
                
                HStack{
                    Text(homeViewModel.selectedPasswordData?.emailUsername ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.fontBlack)
                        .contextMenu(ContextMenu(menuItems: {
                            Button(strCopy, action: {
                                UIPasteboard.general.string = homeViewModel.selectedPasswordData?.emailUsername
                            })
                        }))
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            UIPasteboard.general.string = homeViewModel.selectedPasswordData?.emailUsername
                            BannerAlertsViewModel.shared.show(title: strCopy, alertType: .success)
                        }
                    }, label: {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Color.gray)
                    })                }
            }
            
            VStack(alignment: .leading, spacing: 7){
                Text(strPassword)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.fontTitleGray)
                HStack{
                    Text(isShowPassword ? (homeViewModel.selectedPasswordData?.password ?? "") : String(repeating: "*", count: homeViewModel.selectedPasswordData?.password.count ?? 0))
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.fontBlack)
                        .contextMenu(ContextMenu(menuItems: {
                            Button(strCopy, action: {
                                UIPasteboard.general.string = homeViewModel.selectedPasswordData?.password
                            })
                        }))
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            isShowPassword.toggle()
                        }
                    }, label: {
                        Image(!isShowPassword ? "show" : "eye")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.gray)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                    })
                    
                    
                    Button(action: {
                        withAnimation {
                            UIPasteboard.general.string = homeViewModel.selectedPasswordData?.password
                            BannerAlertsViewModel.shared.show(title: strCopy, alertType: .success)
                        }
                    }, label: {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Color.gray)
                    })
                    
                }
            }
            
            HStack {
                Button(action: {
                    homeViewModel.btnEditAction()
                }, label: {
                    Text(strEdit)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(13)
                        .background(Color.btnBgBlack
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1))
                        .cornerRadius(20.0)
                })
                
                Button(action: {
                    homeViewModel.btnDeleteAction()
                }, label: {
                    Text(strDelete)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(13)
                        .background(Color.btnBgRed
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1))
                        .cornerRadius(20.0)
                })
            }
            .padding(.top, 5)
            
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 7)
        .lineLimit(1)
    }
}

#Preview {
    DetailsViewSheetView(homeViewModel: HomeViewModel())
}

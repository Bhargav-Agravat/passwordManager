//
//  HomeView.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 17/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    
    
    var body: some View {
        //        GeometryReader { geo in
        NavigationView{
            ZStack{
                NavigationLink(destination: SettingsView(), isActive: $homeViewModel.isOpenSettingsView) {
                }
                
                Color.appBg
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0){
                    topNav
                    
                    List{
                        ForEach(Array(homeViewModel.passwordListData.enumerated()), id: \.offset) { index, item in
                            
                            Button(action: {
                                homeViewModel.selectedPasswordData = item
                                homeViewModel.selectedPasswordData?.password = homeViewModel.decryptionPassword(encryptedMessage: item.password)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    homeViewModel.isOpenDetailsSheet = true
                                }
                            }, label: {
                                HStack {
                                    Text(item.accountType)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color.fontBlack)
                                    
                                    Text("*******")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Color.fontPasswordHide)
                                        .offset(y: 4)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.fontBlack)
                                }
                                .padding(EdgeInsets(top: 16, leading: 19, bottom: 16, trailing: 16))
                                .background(Color.white)
                                .cornerRadius(50.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.listBorder, lineWidth: 1)
                                )
                            })
                            .buttonStyle(.plain)
                            .padding(EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16))
                            .padding(.top, index == 0 ? 16 : 0)
                            
                        }
                        .hideListRowSeperator(color: Color.clear)
                        
                    }
                    .listStyle(.plain)
                    .hideIndicator()
                    .pullToRefresh {
                        homeViewModel.fetchPasswordData()
                    }
                    .overlay(
                        ZStack{
                            if homeViewModel.passwordListData.isEmpty{
                                Text("No Data Found")
                                    .foregroundColor(Color.fontTitleGray)
                            }
                        }
                    )
                }
                
                Button(action: {
                    homeViewModel.btnAddAction()
                }, label: {
                    Image("btnAdd")
                })
                .padding(5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
                
                HalfASheet(isPresented: $homeViewModel.isOpenDetailsSheet) {
                    DetailsViewSheetView(homeViewModel: homeViewModel)
                }
                .backgroundColor(.white)
                .closeButtonColor(UIColor.gray)
                .height(.fixed(370))
                
                
                HalfASheet(isPresented: $homeViewModel.isOpenAddPasswordSheet) {
                    AddPasswordSheetView(homeViewModel: homeViewModel)
                }
                .backgroundColor(.white)
                .closeButtonColor(UIColor.gray)
                .height(.fixed(350))
                
                HalfASheet(isPresented: $homeViewModel.isOpenPasswordGenerateSheet) {
                    PasswordGenerateSheetView(homeViewModel: homeViewModel)
                }
                .backgroundColor(.white)
                .closeButtonColor(UIColor.gray)
                .height(.fixed(415))
            }
            .alert(isPresented: $homeViewModel.isShowDeleteAlert) {
                Alert(title: Text(strDelete),
                      message: Text(strDeletMsg),
                      primaryButton: .destructive(Text(strDelete)) {
                    homeViewModel.deletePasswordData()
                },
                      secondaryButton: .cancel())
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear(){
                homeViewModel.fetchPasswordData()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        
    }
    
    var topNav: some View{
        VStack(alignment: .leading, spacing: 0){
            HStack{
                Text(strPasswordManager)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.fontBlack)
                
                Spacer()
                
                Button(action: {
                    homeViewModel.isOpenSettingsView = true
                }, label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color.appBlue)
                })
            }
            .padding()
            
            Color.seprator
                .frame(height: 1)
        }
    }
}

#Preview {
    HomeView()
}

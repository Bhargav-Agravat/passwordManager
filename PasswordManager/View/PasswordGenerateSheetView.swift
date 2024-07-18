//
//  PasswordGenerateSheetView.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import SwiftUI

struct PasswordGenerateSheetView: View {
    @StateObject var homeViewModel: HomeViewModel
    @StateObject var passwordGeneratorViewModel = PasswordGeneratorViewModel()
    
    @State private var generatedPassword = ""
    @State private var uppercased = true
    @State private var specialCharacters = true
    @State private var characterCount = 20.0
    @State private var withNumbers = true
    @State private var characters = [String]()
    @State private var currentPasswordEntropy = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25){
            Text(strAutoGeneratePassword)
                .font(.system(size: 19, weight: .semibold))
                .foregroundColor(Color.appBlue)
            
            Text(generatedPassword)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity)
            
            HStack{
                Text("\(Int(characterCount))")
                
                Slider(value: $characterCount, in: passwordGeneratorViewModel.passwordLenghtRange, step: 1)
                    .transition(.opacity)
                Button(action: {
                    passwordGeneratorViewModel.generateButtonHaptic()
                    characters = passwordGeneratorViewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
                    generatedPassword = characters.joined()
                    currentPasswordEntropy = passwordGeneratorViewModel.calculatePasswordEntropy(password: characters.joined())
                    passwordGeneratorViewModel.adaptativeSliderHaptic(entropy: currentPasswordEntropy)
                    
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
                
            }
            
            VStack(spacing: 12){
                Toggle(isOn: $specialCharacters, label: {
                    HStack {
                        Text(strSpecialCharacters)
                        Text(strSpecial).foregroundColor(Color.secondary)
                    }
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.appBlue))
                Toggle(isOn: $uppercased, label: {
                    HStack {
                        Text(strUppercaseLetters)
                        Text(strAtoZ).foregroundColor(Color.secondary)
                    }
                    
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.appBlue))
                Toggle(isOn: $withNumbers, label: {
                    HStack {
                        Text(strNumbers)
                        Text(str0To9).foregroundColor(Color.secondary)
                    }
                })
                .toggleStyle(SwitchToggleStyle(tint: Color.appBlue))
            }
            
            HStack {
                Button(action: {
                    homeViewModel.isOpenPasswordGenerateSheet = false
                }, label: {
                    Text(strCancel)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(13)
                        .background(Color.btnBgBlack
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1))
                        .cornerRadius(20.0)
                })
                
                Button(action: {
                    homeViewModel.txtPassword = generatedPassword
                    homeViewModel.isOpenPasswordGenerateSheet = false
                }, label: {
                    Text(strUse)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(13)
                        .background(Color.green.opacity(0.9)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1))
                        .cornerRadius(20.0)
                })
            }
        }
        .foregroundColor(Color.fontBlack)
        .padding(.horizontal, 25)
        .padding(.bottom, 7)
        .lineLimit(1)
        .onChange(of: characterCount, perform: { _ in
            characters = passwordGeneratorViewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = passwordGeneratorViewModel.calculatePasswordEntropy(password: characters.joined())
            passwordGeneratorViewModel.adaptativeSliderHaptic(entropy: currentPasswordEntropy)
        })
        .onChange(of: uppercased, perform: { _ in
            characters = passwordGeneratorViewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = passwordGeneratorViewModel.calculatePasswordEntropy(password: characters.joined())
        })
        .onChange(of: specialCharacters, perform: { _ in
            characters = passwordGeneratorViewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = passwordGeneratorViewModel.calculatePasswordEntropy(password: characters.joined())
        })
        .onChange(of: withNumbers, perform: { _ in
            characters = passwordGeneratorViewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = passwordGeneratorViewModel.calculatePasswordEntropy(password: characters.joined())
        })
        .onAppear(perform: {
            characters = passwordGeneratorViewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = passwordGeneratorViewModel.calculatePasswordEntropy(password: characters.joined())
        })
    }
}

#Preview {
    PasswordGenerateSheetView(homeViewModel: HomeViewModel())
}

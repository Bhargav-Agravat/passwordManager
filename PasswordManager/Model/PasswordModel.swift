//
//  PasswordModel.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import Foundation

struct PasswordModel: Identifiable {
    let id: Int64
    let accountType: String
    let emailUsername: String
    var password: String
    let createdAt: Date
}

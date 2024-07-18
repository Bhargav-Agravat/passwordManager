//
//  DbManager.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import Foundation
import SQLite

class DbManager {
    static let shared = DbManager()
    
    private var db: Connection?
    
    private let passwordsTable = Table("password")
    private let id = Expression<Int64>("id")
    private let accountType = Expression<String>("accountType")
    private let emailUsername = Expression<String>("emailUsername")
    private let password = Expression<String>("password")
    private let createdAt = Expression<Date>("createdAt")
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("passwords").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            
            createTable()
        } catch {
            print("Error connecting to database: \(error)")
        }
    }
    
    private func createTable() {
        let createTable = passwordsTable.create(ifNotExists: true) { table in
            table.column(id, primaryKey: .autoincrement)
            table.column(accountType)
            table.column(emailUsername)
            table.column(password)
            table.column(createdAt)
        }
        
        do {
            try db?.run(createTable)
        } catch {
            print("Error creating table: \(error)")
        }
    }
    
    func insertPassword(accountType: String, emailUsername: String, password: String, createdAt: Date) -> (Bool, String?){
        let insert = passwordsTable.insert(
            self.accountType <- accountType,
            self.emailUsername <- emailUsername,
            self.password <- password,
            self.createdAt <- createdAt
        )
        
        do {
            try db?.run(insert)
            return (true, nil)
        } catch {
            print("Error inserting password: \(error)")
            return (false, error.localizedDescription)
        }
    }
    
    func updatePassword(id: Int64, accountType: String, emailUsername: String, password: String) -> (Bool, String?) {
        let passwordToUpdate = passwordsTable.filter(self.id == id)
        let update = passwordToUpdate.update(
            self.accountType <- accountType,
            self.emailUsername <- emailUsername,
            self.password <- password
        )
        
        do {
            if try db?.run(update) ?? 0 > 0 {
                return (true, nil)
            } else {
                return (false, "No password found.")
            }
        } catch {
            return (false, error.localizedDescription)
        }
    }
    
    func deletePassword(id: Int64) -> (Bool, String?) {
        let passwordToDelete = passwordsTable.filter(self.id == id)
        let delete = passwordToDelete.delete()
        
        do {
            if try db?.run(delete) ?? 0 > 0 {
                return (true, nil)
            } else {
                return (false, "No password found with the specified id.")
            }
        } catch {
            return (false, error.localizedDescription)
        }
    }
    
    func fetchPasswords() -> [PasswordModel] {
        var passwords = [PasswordModel]()
        
        do {
            for password in try db!.prepare(passwordsTable) {
                let idValue = password[id]
                let accountTypeValue = password[accountType]
                let emailUsernameValue = password[emailUsername]
                let passwordValue = password[self.password]
                let createdAtValue = password[createdAt]
                
                let passwordModel = PasswordModel(id: idValue, accountType: accountTypeValue, emailUsername: emailUsernameValue, password: passwordValue, createdAt: createdAtValue)
                passwords.append(passwordModel)
            }
        } catch {
            passwords = []
            print("Error fetching passwords: \(error)")
        }
        
        return passwords
    }
    
}

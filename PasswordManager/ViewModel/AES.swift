//
//  AES.swift
//  PasswordManager
//
//  Created by Bhargav Agravat on 18/07/24.
//

import Foundation
import RNCryptor

class AES {
    static var shared = AES()
    
    // Encrypts a message using the specified encryption key.
    func encryptMessage(message: String, encryptionKey: String) throws -> String {
        guard let messageData = message.data(using: .utf8) else {
            throw EncryptionError.invalidMessage
        }
        
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData.base64EncodedString()
    }
    
    // Decrypts an encrypted message using the specified encryption key.
    func decryptMessage(encryptedMessage: String, encryptionKey: String) throws -> String {
        guard let encryptedData = Data(base64Encoded: encryptedMessage) else {
            throw EncryptionError.invalidEncryptedMessage
        }
        
        let decryptedData = try RNCryptor.decrypt(data: encryptedData, withPassword: encryptionKey)
        
        guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            throw EncryptionError.decryptionFailed
        }
        
        return decryptedString
    }
    
    // Custom error type for encryption-related errors
    enum EncryptionError: Error {
        case invalidMessage
        case invalidEncryptedMessage
        case decryptionFailed
    }
}


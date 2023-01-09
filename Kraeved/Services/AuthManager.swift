//
//  AuthManager.swift
//  Kraeved
//
//  Created by Владимир Амелькин on 05.01.2023.
//

import Foundation

// MARK: - AuthManagerProtocol
protocol AuthManagerProtocol: AnyObject {
    func login(phone: String, code: String) -> Bool
    func logout()
    func getUserData() -> String?
}

// MARK: - AuthManager
final class AuthManager: AuthManagerProtocol {
    static let shared = AuthManager()
    
    // MARK: Public Methods
    @discardableResult
    func login(phone: String, code: String) -> Bool {
        let keychainItemQuery = [
            kSecValueData: code.data(using: .utf8)!,
            kSecAttrAccount: phone,
            kSecAttrServer: "kraeved.ru",
            kSecClass: kSecClassInternetPassword,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        let status = SecItemAdd(keychainItemQuery, nil)
        debugPrint("Operation finished with status: \(status)")
        
        return status == 0
    }
    
    func logout() {
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrServer: "kraeved.ru"
        ] as CFDictionary

        SecItemDelete(query)
    }
    
    func getUserData() -> String? {
        let query = [
            kSecAttrServer: "kraeved.ru",
            kSecClass: kSecClassInternetPassword,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        debugPrint("Operation finished with status: \(status)")
        guard let dic = result as? NSDictionary else { return nil }

        let phone = dic[kSecAttrAccount] ?? ""
        guard let codeData = dic[kSecValueData] as? Data else { return nil }
        let code = String(data: codeData, encoding: .utf8)!
        debugPrint("Phone: \(phone)")
        debugPrint("Code: \(code)")
        return phone as? String
    }
}

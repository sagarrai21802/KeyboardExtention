//  KeychainService.swift
//  VoiceKeyboard
//
//  Created by Assistant on 20/11/25.
//
//  A minimal Keychain wrapper for storing/retrieving the Groq API key securely.

import Foundation
import Security

enum KeychainService {
    private static let service = "com.yourcompany.VoiceKeyboard" // Update bundle identifier if needed
    private static let account = "groq_api_key"

    @discardableResult
    static func setGroqAPIKey(_ key: String) -> Bool {
        let keyData = key.data(using: .utf8) ?? Data()

        // Delete any existing item first
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)

        // Add new item
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: keyData,
            // Accessible after first device unlock; adjust if you need stricter access
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }

    static func getGroqAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data, let key = String(data: data, encoding: .utf8) else {
            return nil
        }
        return key
    }

    @discardableResult
    static func deleteGroqAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

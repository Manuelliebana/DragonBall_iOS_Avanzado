//
//  MockSegureDataUserDefault.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 19/7/25.
//

import Foundation
@testable import DragonBall_iOS_Avanzado

struct MockSegureDataUserDefault: SecureDataKeychainProtocol {
    
    let userDefaults = UserDefaults.standard
    let keyToken = "keyToken"
    
    func setToken(token: String) {
        userDefaults.setValue(token, forKey: keyToken)
    }
    
    func getToken() -> String? {
        userDefaults.value(forKey: keyToken) as? String
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: keyToken)
    }
}

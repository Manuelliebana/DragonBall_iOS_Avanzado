//
//  SplashViewModel.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

final class SplashViewModel {
    
    private var secureData : SecureDataKeychainProtocol
    
    //MARK: - Binding con UI
    var modelStatusLoad: ((SplashStatusLoad) -> Void)?
    
    //MARK: - Inits
    init(secureData: SecureDataKeychainProtocol = SecureDataKeychain()) {
        self.secureData = secureData
    }
    
    //MARK: - Methods Check Token
    func checkToken() {
        modelStatusLoad?(.loading)
        guard (secureData.getToken() != nil) else {
            modelStatusLoad?(.noToken)
            return
        }
        modelStatusLoad?(.haveToken)
    }
}

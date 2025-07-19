//
//  LoginViewModel.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import Foundation

final class LoginViewModel {
    
    //MARK: - Binding con UI
    var loginViewState: ((LoginStatusLoad) -> Void)?
    
    //MARK: - Binding con Api
    private let apiProvider: ApiProvider
    
    //MARK: - Inits
    init(apiProvider: ApiProvider = ApiProvider()) {
        self.apiProvider = apiProvider
    }
    
    //MARK: - Methods Login
    func onLoginButton(email: String?, password: String?) {
        loginViewState?(.loading(true))
        
        guard let email = email, isValid(email: email) else {
            loginViewState?(.loading(false))
            loginViewState?(.showErrorEmail("Error en el email"))
            return
        }
        
        guard let password = password, isValid(password: password) else {
            loginViewState?(.loading(false))
            loginViewState?(.showErrorPassword("Error en el password"))
            return
        }
        
        apiProvider.loginWith(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.loginViewState?(.loaded)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.loginViewState?(.errorNetwork(_error: error.description))
                }
            }
        }
    }
    
    private func isValid(email: String) -> Bool {
        email.isEmpty == false && email.contains("@")
    }
    
    private func isValid(password: String) -> Bool {
        password.isEmpty == false && password.count >= 4
    }
}

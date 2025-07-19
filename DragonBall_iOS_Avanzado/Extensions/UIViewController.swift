//
//  UIViewController.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import UIKit

extension UIViewController {
    
    func setupNavigationBarWithLogout() {
        navigationController?.navigationBar.tintColor = UIColor.customColor2
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let symbolImage = UIImage(systemName: "power", withConfiguration: symbolConfiguration)
        
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(symbolImage, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: logoutButton)
        
        navigationItem.rightBarButtonItem = barButton
    }
    

    
    @objc func logoutTapped() {
        // Limpiar la BDD antes del logout
        StoreDataProvider.shared.clearBBDD()
        
        // Limpiar el token de autenticación
        let secureData = SecureDataKeychain()
        secureData.deleteToken()
        
        let backVC = LoginViewController()
        self.navigationController?.setViewControllers([backVC], animated: true)
    }
    

}

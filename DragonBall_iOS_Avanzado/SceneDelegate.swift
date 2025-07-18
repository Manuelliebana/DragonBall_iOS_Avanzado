//
//  SceneDelegate.swift
//  DragonBall_iOS_Avanzado
//
//  Created by Manuel Liebana Montoro on 18/7/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let splashVC = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}




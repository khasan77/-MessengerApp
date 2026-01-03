//  SceneDelegate.swift
//  Messenger
//  Created by Хасан Магомедов on 25.03.2024.

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
                
        if Auth.auth().currentUser != nil {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
    }
}


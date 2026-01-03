//  SceneDelegate.swift
//  Messenger
//  Created by Хасан Магомедов on 25.03.2024.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = ConversationsViewController()
        window?.makeKeyAndVisible()
    }
}


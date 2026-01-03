//
//  MainTabBarController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 25.03.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {

    private var conversationsViewController: UINavigationController {
        let viewController = ConversationsViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        return navigationViewController
    }
    
    private var settingsViewController: UINavigationController {
        let viewController = SettingsViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        
        return navigationViewController
    }
    
    // MARK: - Init 
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [conversationsViewController, settingsViewController]
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

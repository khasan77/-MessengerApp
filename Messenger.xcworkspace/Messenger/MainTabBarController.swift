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
        navigationViewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        return navigationViewController
    }
    
    private var profileViewController: UINavigationController {
        let viewController = ConversationsViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        return navigationViewController
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        viewControllers = [conversationsViewController, profileViewController]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

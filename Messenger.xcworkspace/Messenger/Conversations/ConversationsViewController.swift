//  ConversationsViewController.swift
//  Messenger
//  Created by Хасан Магомедов on 25.03.2024.

import UIKit

final class ConversationsViewController: UIViewController {
    
    private var isFirstLaunch = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        title = "Chats"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isFirstLaunch {
            showLoginScreen()
        }
        
        isFirstLaunch = false 
    }
    
    // MARK: - Private methods
    
    private func showLoginScreen() {
        let viewController = LoginViewController()
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
}

//
//  LoginViewController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 25.03.2024.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let mainView = LoginView()
    
    // MARK: - Lyfecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupActions()
    }
}

// MARK: - Actions

extension LoginViewController {
    
    private func setupActions() {
        mainView.loginButton.addAction(
            UIAction { [weak self] _ in
                self?.loginButtonTapped()
            },
            for: .touchUpInside
        )
        
        mainView.registerButton.addAction(
            UIAction { [weak self] _ in
                self?.registerButtonTapped()
            },
            for: .touchUpInside
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(registrationDidFinish),
            name: Notifications.registrationDidFinish,
            object: nil
        )
    }
}

// MARK: - Private methods

extension LoginViewController {
    
    private func loginButtonTapped() {
        guard
            let email = mainView.emailTextField.text,
            let password = mainView.passwordTextField.text,
            !email.isEmpty, !password.isEmpty
        else {
            showAlert(title: "Ошибка", message: "Введите email и пароль")
            return
        }
        
        // Вход через Firebase
        AuthManager.shared.loginUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = scene.windows.first else { return }
                    window.rootViewController = MainTabBarController()
                case .failure(let error):
                    self.showAlert(title: "Ошибка", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func registerButtonTapped() {
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    @objc
    private func registrationDidFinish() {
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okACtion = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okACtion)
        
        present(alertController, animated: true)
    }
}

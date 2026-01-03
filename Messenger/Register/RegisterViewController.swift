//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 26.03.2024.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    private let mainView = RegisterView()
    
    // MARK: - Lyfecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupActions()
        
        mainView.usernameTextField.delegate = self
        mainView.emailTextField.delegate = self
        mainView.passwordTextField.delegate = self
        mainView.passwordConfirmTextField.delegate = self
    }
        
    // MARK: - Actions
    
    private func setupActions() {
        mainView.loginButton.addAction(
            UIAction { [weak self] _ in
                self?.loginButtonTapped()
            },
            for:.touchDown
        )
        
        mainView.registerButton.addAction(
            UIAction { [weak self] _ in
                self?.registerButtonTapped()
            },
            for: .touchDown
        )
        
        mainView.profileImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(profileImageViewTapped)
            )
        )
    }
}

// MARK: - Handle Data

extension RegisterViewController {
    
    private func handleEmail(_ email: String) -> Bool {
        guard email.count >= 6,
              email.firstIndex(of: "@") != nil,
              email.firstIndex(of: ".") != nil
        else {
            showAlert(title: "Ошибка", message: "Неверный email")
            return false
        }
        
        return true
    }
    
    private func handleUsername(_ username: String) -> Bool {
        guard username.count >= 6 else {
            showAlert(title: "Ошибка", message: "Неверный email")
            return false
        }
        
        return true
    }
    
    private func handlePassword(_ password: String, confirmation: String) -> Bool {
        if password.count  < 8 {
            showAlert(title: "Ошибка", message: "Длина пароля меньше 8 символов")
            return false
        }
        
        if password != confirmation {
            showAlert(title: "Ошибка", message: "Пароли не совпадают")
            return false
        }
        
        return true
    }
}

// MARK: - Data

extension RegisterViewController {
    
    private func registerButtonTapped() {
        guard
            let email = mainView.emailTextField.text,
            let username = mainView.usernameTextField.text,
            let password = mainView.passwordTextField.text,
            let confirmation = mainView.passwordConfirmTextField.text,
            let image = mainView.profileImageView.image,
            image != UIImage(named: "person") // проверяем, выбрал ли юзер фото
        else {
            showAlert(title: "Ошибка", message: "Заполните все поля и выберите фото")
            return
        }
        
        guard handleUsername(username),
              handleEmail(email),
              handlePassword(password, confirmation: confirmation) else {
            return
        }
        
        // Сначала загружаем фото в Storage
        StorageManager.shared.uploadProfileImage(image, userEmail: email) { result in
            switch result {
            case .failure(let error):
                self.showAlert(title: "Ошибка загрузки фото", message: error.localizedDescription)
                
            case .success(let downloadURL):
                print("Фото загружено: \(downloadURL)")
                
                // Теперь выполняем регистрацию Firebase Auth
                AuthManager.shared.registerUser(
                    email: email,
                    password: password,
                    username: username,
                    profileImageView: downloadURL // ← передаем URL
                ) { result in
                    switch result {
                    case .success:
                        NotificationCenter.default.post(name: Notifications.registrationDidFinish, object: nil)
                    case .failure(let error):
                        self.showAlert(title: "Ошибка", message: error.localizedDescription)
                    }
                }
            }
        }
    }

    private func loginButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Alert

extension RegisterViewController {
    
    @objc
    private func profileImageViewTapped() {
        let alertController = UIAlertController(title: "Выберите способ", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "При помощи камеры", style: .default) { [weak self] _ in
            self?.showCameraPicker()
        }
        let libraryAction = UIAlertAction(title: "Из библиотеки", style: .default) { [weak self] _ in
            self?.showGalleryPicker()
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        
        present(alertController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okACtion = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(okACtion)
        
        present(alertController, animated: true)
    }
}

// MARK: - ImagePicker

extension RegisterViewController {
    
    private func showCameraPicker() {
        let viewController = UIImagePickerController()
        viewController.delegate = self
        viewController.sourceType = .camera
        
        present(viewController, animated: true)
    }
    
    private func showGalleryPicker() {
        let viewController = UIImagePickerController()
        viewController.delegate = self
        viewController.sourceType = .photoLibrary
        viewController.allowsEditing = true
        
        present(viewController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        
        mainView.profileImageView.image = image
        
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === mainView.usernameTextField {
            mainView.emailTextField.becomeFirstResponder()
        } else if textField === mainView.emailTextField {
            mainView.passwordTextField.becomeFirstResponder()
        } else if textField === mainView.passwordTextField {
            mainView.passwordConfirmTextField.becomeFirstResponder()
        } else {
            mainView.passwordConfirmTextField.resignFirstResponder()
            registerButtonTapped()
        }

        return true
    }
}

// MARK: - UINavigationControllerDelegate

extension RegisterViewController: UINavigationControllerDelegate {}

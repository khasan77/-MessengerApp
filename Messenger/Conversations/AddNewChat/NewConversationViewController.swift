//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 16.11.2025.
//

import UIKit

protocol NewConversationDelegate: AnyObject {
    func didCreateNewContact(_ contact: Contact)
}

final class NewConversationViewController: UIViewController {
    
    weak var delegate: NewConversationDelegate?
    
    // MARK: - UI Components
    
    private lazy var nameTextField = BaseComponentsFactory.textFieldFactory(title: "Имя")
    private lazy var phoneTextField = BaseComponentsFactory.textFieldFactory(title: "Номер телефона")
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать контакт", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
        
        view.backgroundColor = UIColor.systemGroupedBackground
        
        createButton.addAction(
            UIAction { [weak self] _ in
                self?.createButtonTapped()
            },
            for: .touchDown
        )
    }
    
    // MARK: - Private methods
    
    private func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty
        else { return }
        
        let newContact = Contact(name: name, phoneNumber: phone)
        delegate?.didCreateNewContact(newContact)
        
        dismiss(animated: true)
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextField

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

// MARK: - Layout

extension NewConversationViewController {
    
    private func setupLayout() {
        setupNavigationBarLayout()
        setupStackViewLayout()
    }
    
    private func setupNavigationBarLayout() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        searchBar.becomeFirstResponder()
    }
    
    private func setupStackViewLayout() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(phoneTextField)
        stackView.addArrangedSubview(createButton)
        
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
}

// MARK: - UISearchBarDelegate

extension NewConversationViewController: UISearchBarDelegate {}

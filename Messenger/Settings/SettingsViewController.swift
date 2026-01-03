//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 25.03.2024.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController {
    
    private let searchController = UISearchController()
    private var user: User?
    
    private let sectionTitles = [
        "Аккаунт",
        "Приватность",
        "Уведомления",
        "Избранное"
    ]
    
    private let sectionItems: [[String]] = [
        ["Безопасность аккаунта", "Изменить пароль"],
        ["Кто видит мой статус", "Чёрный список"],
        ["Push-уведомления", "Звуки"],
        ["Избранные чаты"]
    ]

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Настройки"
        
        tableView.dataSource = self
        tableView.delegate = self

        
        setupNavigationBarLayout()
        setupTableViewLayout()
        
        fetchData()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBarLayout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
    }

    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func fetchData() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Пользователь не авторизован")
            return
        }
        
        let username = currentUser.displayName ?? "Без имени"
        let email = currentUser.email ?? "Нет почты"
        let photoURL = currentUser.photoURL
        
        self.user = User(username: username, email: email, profileImageView: photoURL)
        
        updateUI()
    }
    
    private func updateUI() {
        guard let user = user else { return }
        
        let header = ProfileHeaderView()
        header.configure(with: user)
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 240)
        
        tableView.tableHeaderView = header
        tableView.reloadData()
    }

    @objc
    private func logoutTapped() {
        AuthManager.shared.logout { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self?.present(loginVC, animated: true)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 16
        
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        var corners: UIRectCorner = []
        
        if isFirst { corners.insert([.topLeft, .topRight]) }
        if isLast { corners.insert([.bottomLeft, .bottomRight]) }
        
        let path = UIBezierPath(
            roundedRect: cell.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        cell.layer.mask = mask
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + sectionTitles.count  // 0 = профиль
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 0 } // профиль в headerView
        
        return sectionItems[section - 1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath
        ) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        
        let sectionIndex = indexPath.section - 1
        cell.textLabel?.text = sectionItems[sectionIndex][indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return sectionTitles[section - 1]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionIndex = indexPath.section - 1
        let item = sectionItems[sectionIndex][indexPath.row]
        
        let vc = SettingsDetailViewController(title: item)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

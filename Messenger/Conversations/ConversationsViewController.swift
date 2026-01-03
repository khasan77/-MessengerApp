//  ConversationsViewController.swift
//  Messenger
//  Created by Хасан Магомедов on 25.03.2024.

import UIKit

final class ConversationsViewController: UIViewController {
    
    private var contacts: [Contact] = []
    
    private var isFirstLaunch = true
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationsTableViewCell.self, forCellReuseIdentifier: ConversationsTableViewCell.identifier)
        tableView.rowHeight = 80
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        title = "Chats"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        contacts = StorageManager.shared.loadContacts()
        
        setupTableViewLayout()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewChatTapped)
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isFirstLaunch && !AuthManager.shared.isSignedIn {
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
    
    private func setupTableViewLayout() {
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc
    private func addNewChatTapped() {
        let vc = NewConversationViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    private func sortContacts() {
        contacts.sort {
            if $0.isPinned == $1.isPinned {
                return $0.name < $1.name
            }
            return $0.isPinned && !$1.isPinned
        }
    }
    
    func insertNewContact(_ contact: Contact) {
        // Находим последний чат после закреплённого
        let pinnedCount = contacts.filter { $0.isPinned }.count
        
        // Вставляем новый чат сразу после закреплённых
        contacts.insert(contact, at: pinnedCount)
        
        StorageManager.shared.saveContacts(contacts)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ConversationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTableViewCell.identifier, for: indexPath) as? ConversationsTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.configure(with: contacts[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, done in
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            StorageManager.shared.saveContacts(self.contacts)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let isPinned = contacts[indexPath.row].isPinned
        
        let pinAction = UIContextualAction(style: .normal, title: isPinned ? "Unpin" : "Pin") { _, _, done in
            self.contacts[indexPath.row].isPinned.toggle()
            self.sortContacts()
            tableView.reloadData()
            
            StorageManager.shared.saveContacts(self.contacts)
        }
        
        pinAction.backgroundColor = isPinned ? .systemGray : .systemBlue
        pinAction.image = UIImage(systemName: isPinned ? "pin.slash" : "pin")
        
        return UISwipeActionsConfiguration(actions: [pinAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - NewConversationDelegate

extension ConversationsViewController: NewConversationDelegate {
    func didCreateNewContact(_ contact: Contact) {
        insertNewContact(contact)
        StorageManager.shared.saveContacts(contacts)
        tableView.reloadData()
    }
}

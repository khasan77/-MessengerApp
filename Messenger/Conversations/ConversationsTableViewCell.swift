//
//  ConversationsTableViewCell.swift
//  Messenger
//
//  Created by Хасан Магомедов on 16.11.2025.
//

import UIKit

final class ConversationsTableViewCell: UITableViewCell {
    
    static let identifier = "ConversationsTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .medium)
        return label
    }()

    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        avatarImageView.image = UIImage(systemName: "person.circle")
    }
}

// MARK: - Layout

extension ConversationsTableViewCell {
    
    private func setupLayout() {
        setupAvatarImageViewLayout()
        setupNameLabelLayout()
    }
    
    private func setupAvatarImageViewLayout() {
        contentView.addSubview(avatarImageView)
        
        avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupNameLabelLayout() {
        contentView.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    }
}

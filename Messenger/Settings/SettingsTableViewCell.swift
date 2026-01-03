//
//  SettingsTableViewCell.swift
//  Messenger
//
//  Created by Хасан Магомедов on 11.11.2025.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = "SettingsTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .systemGray
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 35
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        titleLabel.text = user.username
        subtitleLabel.text = user.email
        
        if let url = user.profileImageView, let imageURL = URL(string: url.absoluteString) {
            // Загружаем фото асинхронно
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .gray
        }
    }
}

// MARK: - Layout

extension SettingsTableViewCell {
    
    private func setupLayout() {
        setupProfileImageViewLayout()
        setupTitleLabelLayout()
        setupSubTitleLabelLayout()
    }
    
    private func setupProfileImageViewLayout() {
        contentView.addSubview(profileImageView)
        
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setupTitleLabelLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
    }
    
    private func setupSubTitleLabelLayout() {
        contentView.addSubview(subtitleLabel)
        
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }
}

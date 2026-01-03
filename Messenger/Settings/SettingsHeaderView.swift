//
//  SettingsHeaderView.swift
//  Messenger
//
//  Created by Хасан Магомедов on 11.11.2025.
//

import UIKit

final class ProfileHeaderView: UIView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        nameLabel.text = user.username
        
        if let url = user.profileImageView {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = img
                    }
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
            profileImageView.tintColor = .gray
        }
    }
}

extension ProfileHeaderView {
    
    private func setupLayout() {
        setupProfileImageViewLayout()
        setupNameLabelLayout()
    }
    
    private func setupProfileImageViewLayout() {
        addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    private func setupNameLabelLayout() {
        addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 6).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
}

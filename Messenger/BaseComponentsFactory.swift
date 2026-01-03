//
//  BaseComponentsFactory.swift
//  Messenger
//
//  Created by Хасан Магомедов on 26.03.2024.
//

import UIKit

struct BaseComponentsFactory {
    
    static func textFieldFactory(title: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = title
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(12)
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }
    
    static func makeTextField(placeholder: String?) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.backgroundColor = Colors.lightGrayBackgroundColor
        textField.layer.cornerRadius = LayoutMetrics.module
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: .init(x: 0, y: 0, width: LayoutMetrics.doubleModule, height: 0))
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.lightGrayBorderColor.cgColor
        textField.heightAnchor.constraint(equalToConstant: LayoutMetrics.module * 7).isActive = true
        // Отключаем автокоррекцию и автокапитализацию
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }
    
    static func makeActionButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = Colors.buttonDark
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = LayoutMetrics.module
        button.heightAnchor.constraint(equalToConstant: LayoutMetrics.module * 7).isActive = true 
        return button
    }
    
    static func makeGreetingLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .boldSystemFont(ofSize: 30)
        label.numberOfLines = 2
        return label
    }
}

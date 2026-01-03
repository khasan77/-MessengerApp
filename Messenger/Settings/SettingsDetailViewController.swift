//
//  SettingsDetailViewController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 17.11.2025.
//

import UIKit

final class SettingsDetailViewController: UIViewController {
    
    private let titleLabel: String
    
    init(title: String) {
        self.titleLabel = title
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = titleLabel
    }
}

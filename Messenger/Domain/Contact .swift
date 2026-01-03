//
//  Contact .swift
//  Messenger
//
//  Created by Хасан Магомедов on 18.11.2025.
//

import UIKit

struct Contact: Codable {
    let name: String
    let phoneNumber: String
    var isPinned: Bool = false
}

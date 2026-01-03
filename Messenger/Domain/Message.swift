//
//  MessageType.swift
//  Messenger
//
//  Created by Хасан Магомедов on 16.11.2025.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

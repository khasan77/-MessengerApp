//
//  ChatsViewController.swift
//  Messenger
//
//  Created by Хасан Магомедов on 16.11.2025.
//

import UIKit
import MessageKit

final class ChatsViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private let selfSender = Sender(
        photoURL: "",
        senderId: "1",
        displayName: "Angelina Jolie"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(
            Message(
                sender: selfSender,
                messageId: "1",
                sentDate: Date(),
                kind: .text("i love you man")
            )
        )

        view.backgroundColor = .white
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatsViewController: MessagesDataSource {
    
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatsViewController: MessagesLayoutDelegate {}

extension ChatsViewController: MessagesDisplayDelegate {}

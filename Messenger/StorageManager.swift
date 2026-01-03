//
//  StorageManager.swift
//  Messenger
//
//  Created by Хасан Магомедов on 16.11.2025.
//

import FirebaseStorage
import UIKit

final class StorageManager {
    
    private let key = "saved_contacts"
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    func saveContacts(_ contacts: [Contact]) {
        if let data = try? JSONEncoder().encode(contacts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadContacts() -> [Contact] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let contacts = try? JSONDecoder().decode([Contact].self, from: data) else {
            return []
        }
        return contacts
    }
    
    typealias UploadProfileImage = (Result<String, Error>) -> Void
    
    // Сохраняем фото в Storage
    func uploadProfileImage(_ image: UIImage, userEmail: String, completion: @escaping UploadProfileImage)  {
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "image-error", code: -1)))
            return
        }
        
        let safeEmail = userEmail.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        
        let filePath = "profileImages/\(safeEmail).jpg"
        let ref = storage.child(filePath)
        
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            ref.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
}

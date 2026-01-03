//
//  AuthManager .swift
//  Messenger
//
//  Created by Хасан Магомедов on 09.11.2025.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    // Регистрация
    func registerUser(email: String, password: String, username: String, profileImageView: String?, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Firebase Auth Error: \(error.localizedDescription)")
                print("Full error: \(error)")
                completion(.failure(error))
                return
            }
            if let result = result {
                completion(.success(result))
            }
            
            guard let user = result?.user else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }
            
            // После регистрации сохраняем имя и фото в профиле Firebase Auth
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            if let profileImageView = profileImageView {
                changeRequest.photoURL = URL(string: profileImageView)
            }
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Failed to save profile info:", error.localizedDescription)
                } else {
                    print("User profile updated successfully")
                }
                completion(.success(result!))
            }
        }
    }
    
    // Вход
    func loginUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                completion(.success(result))
            }
        }
    }
    
    // Выход
    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    // Проверка авторизации
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
}



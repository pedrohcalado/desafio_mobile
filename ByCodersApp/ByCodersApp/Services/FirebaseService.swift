//
//  FirebaseService.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 02/12/22.
//

import FirebaseFirestore
import Firebase

protocol LoginServiceProtocol {
    typealias Result = Swift.Result<AuthDataResult?, Error>
    func login(email: String, password: String, completion: @escaping (Result) -> Void)
}

protocol SignUpServiceProtocol {
    typealias Result = Swift.Result<AuthDataResult?, Error>
    func createUser(email: String, password: String, completion: @escaping (Result) -> Void)
}

class FirebaseService: LoginServiceProtocol, SignUpServiceProtocol {
    
    public enum Error: Swift.Error {
        case invalidData
        case save
    }
    
    public typealias Result = LoginServiceProtocol.Result
    
    func login(email: String, password: String, completion: @escaping (Result) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let _ = error {
                completion(.failure(FirebaseService.Error.invalidData))
            } else {
                self?.sendLoginAnalyticsEvent(uid: result?.user.uid ?? "", email: result?.user.email ?? "")
                completion(.success(result))
            }
        }
    }
    
    private func sendLoginAnalyticsEvent(uid: String, email: String) {
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
            "uid": uid,
            "email": email
        ])
    }
    
    func createUser(email: String, password: String, completion: @escaping (Result) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if let _ = error {
                completion(.failure(FirebaseService.Error.invalidData))
            } else {
                guard let uid = result?.user.uid else { return }
                self?.saveUserDataOnFirestore(uid: uid, email: email, password: password) { _ in }
                completion(.success(.none))
            }
        }
    }
    
    func saveUserDataOnFirestore(uid: String, email: String, password: String, completion: @escaping (Result) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").addDocument(data: [
            "email": email,
            "password": password,
            "uid": uid
        ]) { error in
            if let _ = error {
                completion(.failure(FirebaseService.Error.save))
            }
            completion(.success(.none))
        }
    }
}

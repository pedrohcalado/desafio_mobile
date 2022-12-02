//
//  SignUpViewModel.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import FirebaseFirestore
import Firebase

protocol SignUpViewModelProtocol {
    func createUser(email: String, password: String)
    var showError: ((String) -> Void)? { get set }
}

class SignUpViewModel: SignUpViewModelProtocol {
    weak var coordinator: RootCoordinator?
    
    var showError: ((String) -> Void)?
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }
    
    func createUser(email: String, password: String) {
        if let error = validateFields(email: email, password: password) {
            showError?(error)
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                if let _ = error {
                    self?.showError?("Ocorreu um erro ao criar o usuário. Por favor, tente novamente.")
                    return
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: [
                        "email": email,
                        "password": password,
                        "uid": result!.user.uid
                    ]) { [weak self] error in
                        if let _ = error { self?.showError?("Erro ao salvar dados do usuário.") }
                    }
                    self?.coordinator?.navigateToLogin()
                }
            }
        }
    }
    
    private func validateFields(email: String?, password: String?) -> String? {
        let emailCleaned = email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let passwordCleaned = password?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if emailCleaned == "" {
            return "O e-mail é obrigatório."
        }
        
        if passwordCleaned == "" {
            return "A senha é obrigatória."
        }
        
        if !emailCleaned.isValidEmail() {
            return "Preencha com um e-mail válido."
        }
        if !passwordCleaned.isValidPassword() {
            return "A senha deve conter pelo menos 8 caracteres, um número e um caracter especial."
        }
        
        return nil
    }
}

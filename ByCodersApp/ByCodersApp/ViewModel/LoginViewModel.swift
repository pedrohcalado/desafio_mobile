//
//  LoginViewModel.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import FirebaseFirestore
import Firebase

protocol LoginViewModelProtocol {
    func login(email: String, password: String)
    func validateFields(email: String?, password: String?) -> String?
    var showError: ((String) -> Void)? { get set }
}

class LoginViewModel: LoginViewModelProtocol {
    weak var coordinator: RootCoordinator?
    
    var showError: ((String) -> Void)?
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let _ = error {
                self?.showError?("Ocorreu um erro ao fazer login. Por favor, tente novamente.")
                return
            }
            self?.saveLoginDataInUserDefaults(uid: result!.user.uid)
            self?.sendLoginAnalyticsEvent(uid: result!.user.uid, email: email)
            self?.coordinator?.navigateToHome()
        }
    }
    
    private func sendLoginAnalyticsEvent(uid: String, email: String) {
        Analytics.logEvent(AnalyticsEventLogin, parameters: [
          "uid": uid,
          "email": email
          ])
    }
    
    private func saveLoginDataInUserDefaults(uid: String) {
        UserDefaults.standard.set(uid, forKey: "uid")
    }
    
    func validateFields(email: String?, password: String?) -> String? {
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


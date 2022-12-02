//
//  SignUpViewModel.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import Foundation

protocol SignUpViewModelProtocol {
    func createUser(email: String, password: String)
    var showError: ((String) -> Void)? { get set }
}

class SignUpViewModel: SignUpViewModelProtocol {
    weak var coordinator: RootCoordinator?
    private var service: SignUpServiceProtocol?
    
    var showError: ((String) -> Void)?
    
    init(coordinator: RootCoordinator, service: SignUpServiceProtocol) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func createUser(email: String, password: String) {
        if let error = validateFields(email: email, password: password) {
            showError?(error)
        } else {
            service?.createUser(email: email, password: password) { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.navigateToLogin()
                case .failure:
                    self?.showError?(NSLocalizedString("user-creation-error", comment: ""))
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

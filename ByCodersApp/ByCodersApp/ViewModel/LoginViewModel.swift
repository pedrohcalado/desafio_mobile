//
//  LoginViewModel.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import Foundation

protocol LoginViewModelProtocol {
    func login(email: String, password: String)
    var showError: ((String) -> Void)? { get set }
}

class LoginViewModel: LoginViewModelProtocol {
    weak var coordinator: RootCoordinator?
    var service: LoginServiceProtocol?
    var showError: ((String) -> Void)?
    
    init(coordinator: RootCoordinator, service: LoginServiceProtocol) {
        self.coordinator = coordinator
        self.service = service
    }
    
    func login(email: String, password: String) {
        if let error = validateFields(email: email, password: password) {
            showError?(error)
        } else {
            service?.login(email: email, password: password) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.saveLoginDataInUserDefaults(uid: data?.uid ?? "")
                    self?.coordinator?.navigateToHome()
                case .failure:
                    self?.showError?("Ocorreu um erro ao fazer login. Por favor, tente novamente.")
                }
            }
        }
    }
    
    private func saveLoginDataInUserDefaults(uid: String) {
        UserDefaults.standard.set(uid, forKey: "uid")
    }
}


//
//  SignUpViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit
import Firebase
import FirebaseFirestore

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        hideErrorMessage()
    }
    
    private func validateFields() -> String? {
        let emailCleaned = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let passwordCleaned = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
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
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        
        if let error = error {
            showError(error)
            return
        }
        
        hideErrorMessage()
        createUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    private func showError(_ message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    private func hideErrorMessage() {
        errorLabel.isHidden = true
    }
    
    private func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if let _ = error {
                self?.showError("Ocorreu um erro ao criar o usuário. Por favor, tente novamente.")
                return
            } else {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: [
                    "email": email,
                    "password": password,
                    "uid": result!.user.uid
                ]) { [weak self] error in
                    if let _ = error { self?.showError("Erro ao salvar dados do usuário.") }
                }
                self?.goToLogin()
            }
        }
    }
    
    private func goToLogin() {
        let login = storyboard?.instantiateViewController(withIdentifier: NSLocalizedString("login-screen", comment: "")) as? LoginViewController
        
        view.window?.rootViewController = login
        view.window?.makeKeyAndVisible()
    }
    
    
    // MARK: - Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideErrorMessage()
    }
    
}

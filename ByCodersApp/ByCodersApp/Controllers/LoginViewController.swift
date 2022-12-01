//
//  LoginViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAnalytics

final class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
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
    @IBAction func loginTapped(_ sender: Any) {
        let error = validateFields()
        
        if let error = error {
            showError(error)
            return
        }
        
        hideErrorMessage()
        login(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func showError(_ message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
    
    private func hideErrorMessage() {
        errorLabel.isHidden = true
    }
    
    private func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let _ = error {
                self?.showError("Ocorreu um erro ao fazer login. Por favor, tente novamente.")
                return
            }
            self?.saveLoginDataInUserDefaults(uid: result!.user.uid)
            self?.sendLoginAnalyticsEvent(uid: result!.user.uid, email: email)
            self?.goToHome()
        }
    }
    
    private func goToHome() {
        let homeScreen = storyboard?.instantiateViewController(withIdentifier: NSLocalizedString("home-screen", comment: "")) as? HomeViewController
        
        view.window?.rootViewController = homeScreen
        view.window?.makeKeyAndVisible()
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
    
    // MARK: - Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideErrorMessage()
    }
}

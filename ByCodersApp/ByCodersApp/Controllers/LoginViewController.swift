//
//  LoginViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit

final class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var viewModel: LoginViewModelProtocol?
    
    init(viewModel: LoginViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        hideErrorMessage()
        
        viewModel?.showError = showError
    }

    @IBAction func loginTapped(_ sender: Any) {
        let error = viewModel?.validateFields(
            email: emailTextField.text,
            password: passwordTextField.text)
        
        if let error = error {
            showError(error)
            return
        }
        
        hideErrorMessage()
        viewModel?.login(email: emailTextField.text!, password: passwordTextField.text!)
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
    
    // MARK: - Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideErrorMessage()
    }
}

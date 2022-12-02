//
//  SignUpViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var viewModel: SignUpViewModelProtocol?
    
    init(viewModel: SignUpViewModelProtocol) {
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
        
        viewModel?.showError = self.showErrorMessage
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = viewModel?.validateFields(
            email: emailTextField.text,
            password: passwordTextField.text)
        
        if let error = error {
            showErrorMessage(error)
            return
        }
        
        hideErrorMessage()
        viewModel?.createUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func showErrorMessage(_ message: String) {
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

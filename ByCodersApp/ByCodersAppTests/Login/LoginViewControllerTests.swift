//
//  LoginViewControllerTests.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 02/12/22.
//

import XCTest

@testable import ByCodersApp
class LoginViewControllerTests: XCTestCase {

    func test_init_doesNotRequestUserCreation() {
        let (sut, viewModel) = makeSUT()
        
        XCTAssertEqual(viewModel.loginCount, 0, "Expect no login requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(viewModel.loginCount, 0, "Expect no login requests after view is loaded")
    }
    
    func test_loginButton_callsCreateUserWhenTapped() {
        let (sut, viewModel) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.loginButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(viewModel.loginCount, 1)
    }
    
    func test_errorMessage_isVisibleWhenLoginButtonTapped() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.loginButton.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(sut.errorLabel.isHidden)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoginViewController, viewModel: LoginViewModelSpy) {
        let viewModel = LoginViewModelSpy()
        let sut = LoginViewController(viewModel: viewModel)
    
        return (sut, viewModel)
    }
}

class LoginViewModelSpy: LoginViewModelProtocol {
    var loginCount = 0
    
    func login(email: String, password: String) {
        loginCount += 1
        if let error = validateFieldsWithError() {
            showError?(error)
        }
    }
    
    var showError: ((String) -> Void)?
    
    private func validateFieldsWithError() -> String? {
        return "Error"
    }
}

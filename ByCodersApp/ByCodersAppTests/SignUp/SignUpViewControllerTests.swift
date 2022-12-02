//
//  SignUpViewControllerTests.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 02/12/22.
//

import XCTest

@testable import ByCodersApp
class SignUpViewControllerTests: XCTestCase {

    func test_init_doesNotRequestUserCreation() {
        let (sut, viewModel) = makeSUT()
        
        XCTAssertEqual(viewModel.createUserCount, 0, "Expect no user creation requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(viewModel.createUserCount, 0, "Expect no user creation requests after view is loaded")
    }
    
    func test_registerButton_callsCreateUserWhenTapped() {
        let (sut, viewModel) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.registerButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(viewModel.createUserCount, 1)
    }
    
    func test_errorMessage_isVisibleWhenLoginButtonTapped() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.registerButton.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(sut.errorLabel.isHidden)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SignUpViewController, viewModel: ViewModelSpy) {
        let viewModel = ViewModelSpy()
        let sut = SignUpViewController(viewModel: viewModel)
    
        return (sut, viewModel)
    }
}

class ViewModelSpy: SignUpViewModelProtocol {
    var createUserCount = 0
    
    func createUser(email: String, password: String) {
        createUserCount += 1
        if let error = validateFieldsWithError() {
            showError?(error)
        }
    }
    
    var showError: ((String) -> Void)?
    
    private func validateFieldsWithError() -> String? {
        return "Error"
    }
    
}

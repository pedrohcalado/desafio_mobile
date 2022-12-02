//
//  SignUpViewControllerTests.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 02/12/22.
//

import XCTest

@testable import ByCodersApp
class SignUpViewControllerTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (sut, viewModel) = makeSUT()
        
        XCTAssertEqual(viewModel.createUserCount, 0, "Expect no user creation requests before view is loaded")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: SignUpViewController, viewModel: ViewModelSpy) {
        let viewModel = ViewModelSpy()
        let sut = SignUpViewController(viewModel: viewModel)
        trackForMemoryLeaks(instance: viewModel, file: file, line: line)
        trackForMemoryLeaks(instance:sut, file: file, line: line)
        return (sut, viewModel)
    }
}

class ViewModelSpy: SignUpViewModelProtocol {
    var createUserCount = 0
    
    func createUser(email: String, password: String) {
        createUserCount += 1
    }
    
    func validateFields(email: String?, password: String?) -> String? {
        return nil
    }
    
    var showError: ((String) -> Void)?
    
    
}

//
//  LoginViewModelTests.swift
//  ByCodersAppTests
//
//  Created by Pedro Henrique Calado on 05/12/22.
//

import XCTest
import Firebase

@testable import ByCodersApp
class LoginViewModelTests: XCTestCase {
    func test_init_serviceIsNotNil() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertNotNil(sut.service)
    }
    
    func test_login_callsNavigateToHomeOnSuccess() {
        let (sut, service, coordinator) = makeSUT()
        
        sut.login(email: "email@test.com", password: "Teste@123")
        let result = UserData(uid: "1", email: "email@test.com")
        service.completeLogin(with: result, at: 0)
        
        XCTAssertEqual(coordinator.navigateToHomeCount, 1)
    }
    
    func test_login_showErrorOnInvalidData() {
        let (sut, _, _) = makeSUT()
        let view = ViewStub(viewModel: sut)
        sut.showError = view.showError

        sut.login(email: "email", password: "Teste@123")
        XCTAssertEqual(view.showErrorMessage, "Preencha com um e-mail válido.")
        
        sut.login(email: "email@teste.com", password: "teste")
        XCTAssertEqual(view.showErrorMessage, "A senha deve conter pelo menos 8 caracteres, um número e um caracter especial.")
        
        sut.login(email: "", password: "Teste@123")
        XCTAssertEqual(view.showErrorMessage, "O e-mail é obrigatório.")
        
        sut.login(email: "email@teste.com", password: "")
        XCTAssertEqual(view.showErrorMessage, "A senha é obrigatória.")
    }
    
}

// MARK: - Helpers

private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoginViewModel, service: LoginServiceStub, coordinator: CoordinatorSpy) {
    let service = LoginServiceStub()
    let coordinator = CoordinatorSpy()
    let sut = LoginViewModel(coordinator: coordinator, service: service)

    return (sut, service, coordinator)
}

class ViewStub: UIView {
    private var viewModel: LoginViewModelProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(viewModel: LoginViewModelProtocol) {
        super.init(frame: CGRect())
        self.viewModel = viewModel
    }
    
    var showErrorMessage: String?
    func showError(_ error: String) {
        showErrorMessage = error
    }
}

class LoginServiceStub: LoginServiceProtocol {
    private var loginRequests = [(FirebaseService.Result) -> Void]()
    
    func login(email: String, password: String, completion: @escaping (FirebaseService.Result) -> Void) {
        loginRequests.append(completion)
    }
    
    func completeLogin(with userData: UserData, at index: Int) {
        loginRequests[index](.success(userData))
    }
    
    func simulateUserLogin() {
        
    }
    
}

class CoordinatorSpy: RootCoordinator {
    
    var navigateToHomeCount = 0
    
    func navigateToSignup() {
        
    }
    
    func navigateToLogin() {
        
    }
    
    func navigateToHome() {
        navigateToHomeCount += 1
    }
    
    
}

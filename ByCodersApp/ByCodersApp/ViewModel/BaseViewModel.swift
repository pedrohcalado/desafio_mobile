//
//  BaseViewModel.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import FirebaseAnalytics

protocol BaseViewModelProtocol {
    func sendCompletedRenderizationAnalyticsEvent()
    func login()
    func signup()
}

class BaseViewModel: BaseViewModelProtocol {
    private weak var coordinator: RootCoordinator?
    
    init(coordinator: RootCoordinator?) {
        self.coordinator = coordinator
    }
    
    func sendCompletedRenderizationAnalyticsEvent() {
        Analytics.logEvent(AnalyticsParameterSuccess, parameters: [
            "viewController": String(describing: BaseViewController.self)
        ])
    }
    
    func login() {
        coordinator?.navigateToLogin()
    }
    
    func signup() {
        coordinator?.navigateToSignup()
    }
}

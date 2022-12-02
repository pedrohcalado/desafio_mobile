//
//  Coordinator.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 01/12/22.
//

import Foundation
import UIKit

protocol RootCoordinator: AnyObject {
    func navigateToSignup()
    func navigateToLogin()
    func navigateToHome()
}

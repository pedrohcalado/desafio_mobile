//
//  ViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit
import FirebaseAnalytics

class BaseViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sendCompletedRenderizationAnalyticsEvent()
    }
    
    private func sendCompletedRenderizationAnalyticsEvent() {
        Analytics.logEvent(AnalyticsParameterSuccess, parameters: [
            "viewController": String(describing: BaseViewController.self)
        ])
    }

}


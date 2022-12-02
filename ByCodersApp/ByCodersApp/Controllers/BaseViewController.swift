//
//  ViewController.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 28/11/22.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    private var viewModel: BaseViewModelProtocol?
    
    init(viewModel: BaseViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel?.sendCompletedRenderizationAnalyticsEvent()
    }

    @IBAction func loginTapped(_ sender: Any) {
        viewModel?.login()
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        viewModel?.signup()
    }
}


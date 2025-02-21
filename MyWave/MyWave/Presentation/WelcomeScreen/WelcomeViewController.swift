//
//  WelcomeViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation
import UIKit

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(.orange)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.handleLogin()
    }
}


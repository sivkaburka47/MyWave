//
//  WelcomeViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation
import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    
    private let welcomeLabel = UILabel()
    private let loginButton = LoginAppleIdButton()
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureTitleLabel()
        configureLoginButton()
    }
    
    private func configureBackground(){
        view.backgroundColor = UIColor(.white)
        let circleSize = max(view.bounds.width, view.bounds.height) / 2
        let animatedView = AnimatedGradientView(frame: view.bounds, circleSize: circleSize)
        view.addSubview(animatedView)

    }
    
    private func configureTitleLabel() {
        welcomeLabel.text = "Добро пожаловать"
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.font = UIFont(name: "Gwen-Trial-Black", size: 48)
        welcomeLabel.textColor = .black
        welcomeLabel.textAlignment = .left
        welcomeLabel.numberOfLines = 2
        view.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    @objc private func loginButtonTapped() {
        viewModel.handleLogin()
    }
}


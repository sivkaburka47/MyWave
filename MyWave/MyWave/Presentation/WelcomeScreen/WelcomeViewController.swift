//
//  WelcomeViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: WelcomeViewModel
    
    private let welcomeLabel = UILabel()
    private let loginButton = LoginAppleIdButton()
    private var animatedGradientView: AnimatedGradientView!
    
    // MARK: - Initialization
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
}

// MARK: - UI Setup

extension WelcomeViewController {
    
    private func setupUI() {
        configureBackground()
        configureWelcomeLabel()
        configureLoginButton()
    }
    
    private func configureBackground() {
        view.backgroundColor = Metrics.Colors.background
        let circleSize = max(view.bounds.width, view.bounds.height) / 2
        animatedGradientView = AnimatedGradientView(frame: view.bounds, circleSize: circleSize)
        view.insertSubview(animatedGradientView, at: 0)
    }
    
    private func configureWelcomeLabel() {
        welcomeLabel.text = Metrics.Strings.welcomeText
        welcomeLabel.font = Metrics.Fonts.titleFont
        welcomeLabel.textColor = Metrics.Colors.text
        welcomeLabel.textAlignment = .left
        welcomeLabel.numberOfLines = 2
        view.addSubview(welcomeLabel)
    }
    
    private func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.contentInsets)
            $0.leading.trailing.equalToSuperview().inset(Constants.contentInsets)
        }
    }
}

// MARK: - Actions

extension WelcomeViewController {
    
    @objc private func loginButtonTapped() {
        viewModel.handleLogin()
    }
}

// MARK: - Constants & Metrics

extension WelcomeViewController {
    
    enum Constants {
        static let contentInsets: CGFloat = 24
    }
    
    enum Metrics {
        enum Colors {
            static let background = UIColor.white
            static let text = UIColor.black
        }
        
        enum Fonts {
            static let titleFont = UIFont(name: "Gwen-Trial-Black", size: 48)!
        }
        
        enum Strings {
            static let welcomeText = LocalizedString.Welcome.welcomeText
        }
    }
}

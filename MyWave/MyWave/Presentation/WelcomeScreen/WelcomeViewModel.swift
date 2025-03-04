//
//  WelcomeViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation

final class WelcomeViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: WelcomeCoordinator?
}

// MARK: - Public Methods

extension WelcomeViewModel {
    
    func handleLogin() {
        coordinator?.completeAuthentication()
    }
}

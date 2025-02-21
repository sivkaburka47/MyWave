//
//  WelcomeViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation

final class WelcomeViewModel {
    weak var coordinator: WelcomeCoordinator?
    
    func handleLogin() {
        coordinator?.navigateToMain()
    }
}

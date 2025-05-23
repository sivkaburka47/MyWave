//
//  WelcomeViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation
import LocalAuthentication

final class WelcomeViewModel {

    weak var coordinator: WelcomeCoordinator?

    func handleLogin() {
        coordinator?.completeAuthentication()
    }

    func authenticateIfNeeded() {
        let isFaceIdEnabled = UserDefaults.standard.bool(forKey: "isFaceIdEnabled")
        guard isFaceIdEnabled else { return }

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Вход с помощью Face ID") { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.coordinator?.completeAuthentication()
                    } else {
                        print("Ошибка авторизации: \(authError?.localizedDescription ?? "Неизвестная ошибка")")
                    }
                }
            }
        }
    }
}

//
//  AppCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    
    func start() {
        if isUserLoggedIn {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        welcomeCoordinator.parentCoordinator = self
        welcomeCoordinator.delegate = self
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showMainFlow() {
        childCoordinators.removeAll { $0 is WelcomeCoordinator }
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
    
    private var isUserLoggedIn: Bool {
        return false
    }
}

extension AppCoordinator: WelcomeCoordinatorDelegate {
    func didAuthenticate() {
        childCoordinators.removeAll()
        showMainFlow()
    }
}

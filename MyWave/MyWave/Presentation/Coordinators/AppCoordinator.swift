//
//  AppCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("AppCoordinator deinitialized")
    }
    
    func start() {
        let isLoggedIn = false
        
        if isLoggedIn {
            showMainFlow()
        } else {
            showWelcomeFlow()
        }
    }
    
    private func showWelcomeFlow() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        welcomeCoordinator.delegate = self
        childCoordinators.append(welcomeCoordinator)
        welcomeCoordinator.start()
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}

extension AppCoordinator: WelcomeCoordinatorDelegate {
    func didFinishWelcomeFlow() {
        print("AppCoordinator: didFinishWelcomeFlow called")
        childCoordinators.removeAll()
        showMainFlow()
    }
}


//
//  MainCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("MainCoordinator deinitialized")
    }

    func start() {
        let viewModel = MainViewModel()
        let vc = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([vc], animated: true)
    }
}

//
//  WelcomeCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

protocol WelcomeCoordinatorDelegate: AnyObject {
    func didFinishWelcomeFlow()
}

final class WelcomeCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var delegate: WelcomeCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = WelcomeViewModel()
        viewModel.coordinator = self
        let vc = WelcomeViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToMain() {
        delegate?.didFinishWelcomeFlow()
    }
}

//
//  OptionsCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

final class OptionsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = OptionsViewModel()
        viewModel.coordinator = self
        let vc = OptionsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
}

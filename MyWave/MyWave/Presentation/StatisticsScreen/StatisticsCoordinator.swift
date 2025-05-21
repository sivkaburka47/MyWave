//
//  StatisticsCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

final class StatisticsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = StatisticsViewModel()
        viewModel.coordinator = self
        let vc = StatisticsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
    
}

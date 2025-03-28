//
//  WelcomeCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

protocol WelcomeCoordinatorDelegate: AnyObject {
    func didAuthenticate()
}

final class WelcomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    weak var delegate: WelcomeCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    func start() {
        let viewModel = WelcomeViewModel()
        viewModel.coordinator = self
        let vc = WelcomeViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func completeAuthentication() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        delegate?.didAuthenticate()
    }
}

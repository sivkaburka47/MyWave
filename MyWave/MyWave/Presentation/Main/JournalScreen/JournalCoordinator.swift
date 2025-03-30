//
//  JournalCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

protocol JournalCoordinatorDelegate: AnyObject {
    func returnToRoot()
}

final class JournalCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    weak var mainCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    func start() {
        let viewModel = JournalViewModel()
        viewModel.coordinator = self
        let vc = JournalViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func navigateToEmotionSelection() {
        let coordinator = EmotionSelectionCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.mainCoordinator = mainCoordinator
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func navigateToAddNote() {
        let coordinator = AddNoteCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        coordinator.mainCoordinator = mainCoordinator
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension JournalCoordinator: EmotionSelectionCoordinatorDelegate, AddNoteCoordinatorDelegate {
    func flowDidFinish() {
        childCoordinators.removeLast()
        mainCoordinator?.returnToRoot()
    }
}

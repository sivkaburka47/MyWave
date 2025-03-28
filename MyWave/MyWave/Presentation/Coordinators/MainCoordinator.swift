//
//  MainCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit
import SnapKit

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    private var tabBarController: UITabBarController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        setupTabBarAppearance()
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    func start() {
        setupTabs()
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.isNavigationBarHidden = true
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "statItemBG")
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarController.tabBar.layer.shadowOpacity = 0.1
        tabBarController.tabBar.layer.shadowRadius = 4
    }
    
    private func setupTabs() {
        tabBarController.viewControllers = [
            createJournalFlow(),
            createStatisticsFlow(),
            createOptionsFlow()
        ]
    }
    
    private func createJournalFlow() -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Журнал",
            image: UIImage(named: "journal")?.withRenderingMode(.alwaysTemplate),
            tag: 0
        )
        let coordinator = JournalCoordinator(navigationController: nav)
        coordinator.mainCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        return nav
    }
    
    private func createStatisticsFlow() -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "statistics")?.withRenderingMode(.alwaysTemplate),
            tag: 1
        )
        let coordinator = StatisticsCoordinator(navigationController: nav)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        return nav
    }
    
    private func createOptionsFlow() -> UINavigationController {
        let nav = UINavigationController()
        nav.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(named: "options")?.withRenderingMode(.alwaysTemplate),
            tag: 2
        )
        let coordinator = OptionsCoordinator(navigationController: nav)
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        coordinator.start()
        return nav
    }
    
    func returnToRoot() {
        tabBarController.selectedIndex = 0
        (tabBarController.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: true)
    }
}

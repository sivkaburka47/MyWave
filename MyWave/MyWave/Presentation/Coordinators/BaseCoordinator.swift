//
//  BaseCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}


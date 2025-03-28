//
//  BaseCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit
import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
}

extension Coordinator {
    func trackDeinit(_ message: String = "") {
        let typeName = String(describing: type(of: self))
        print("+ \(typeName) \(message) tracked")
        
        NotificationCenter.default.addObserver(
            forName: .deinitTracker,
            object: nil,
            queue: .main
        ) { _ in
            print("- \(typeName) деинициализирован")
        }
    }
    
    func validateDeallocation(after delay: TimeInterval = 2.0) {
        let coordinatorType = String(describing: type(of: self))
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            assert(self.childCoordinators.isEmpty, "\(coordinatorType) имеет незавершенные childCoordinators")
        }
    }
}

extension Notification.Name {
    static let deinitTracker = Notification.Name("DeinitTrackerNotification")
}


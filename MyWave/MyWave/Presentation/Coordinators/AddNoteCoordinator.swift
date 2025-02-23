//
//  AddNoteCoordinator.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

protocol AddNoteCoordinatorDelegate: AnyObject {
    func flowDidFinish()
}

final class AddNoteCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    weak var mainCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        trackDeinit()
    }
    
    deinit {
        NotificationCenter.default.post(name: .deinitTracker, object: nil)
    }
    
    func start() {
        let viewModel = AddNoteViewModel()
        viewModel.coordinator = self
        let vc = AddNoteViewController(viewModel: viewModel)
        configureScreen(vc, title: "Новая запись", showBackButton: true)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func configureScreen(_ vc: UIViewController, title: String, showBackButton: Bool) {
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.navigationBar.tintColor = .label
        vc.hidesBottomBarWhenPushed = true
        
        if showBackButton {
            let backButton = UIButton(type: .system)
            backButton.backgroundColor = UIColor(named: "statItemBG")
            backButton.layer.cornerRadius = 20
            backButton.setImage(UIImage(systemName: "arrow.left")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
            backButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
            
            let containerView = UIView()
            containerView.addSubview(backButton)
            backButton.snp.makeConstraints { make in
                make.size.equalTo(40)
                make.edges.equalToSuperview()
            }
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont(name: "Gwen-Trial-Regular", size: 24)!
            titleLabel.textColor = .white
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 16
            let backBarButtonItem = UIBarButtonItem(customView: containerView)
            vc.navigationItem.leftBarButtonItems = [
                backBarButtonItem,
                spacer,
                UIBarButtonItem(customView: titleLabel)
            ]
        } else {
            vc.navigationItem.backButtonTitle = title
        }
        
        vc.navigationController?.navigationBar.isHidden = false
    }
    
    @objc private func popViewController() {
        navigationController.popViewController(animated: true)
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
    }
    
    func completeFlow() {
        mainCoordinator?.returnToRoot()
        parentCoordinator?.childCoordinators.removeAll { $0 === self }
    }
}








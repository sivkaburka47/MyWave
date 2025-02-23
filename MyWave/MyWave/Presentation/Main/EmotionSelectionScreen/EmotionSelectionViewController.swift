//
//  EmotionSelectionViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

final class EmotionSelectionViewController: UIViewController {
    private let viewModel: EmotionSelectionViewModel
    
    init(viewModel: EmotionSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Переход на AddNote", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func nextTapped() {
        viewModel.navigateToAddNote()
    }
}

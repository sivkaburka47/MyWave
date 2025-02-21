//
//  MainViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(.green)
    }

}



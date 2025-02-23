//
//  OptionsViewController.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit
import SnapKit

final class OptionsViewController: UIViewController {
    private let viewModel: OptionsViewModel
    
    init(viewModel: OptionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let titleLabel = UILabel()
        titleLabel.text = "OptionsViewController"
        titleLabel.font = UIFont(name: "Gwen-Trial-Regular", size: 24)!
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

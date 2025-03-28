//
//  LoginAppleIdButton.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit
import SnapKit

final class LoginAppleIdButton: UIButton {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppleLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = "Войти через Apple ID"
        label.font = UIFont(name: "VelaSans-GX", size: 16)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 40
        
        
        snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.equalTo(42)
            make.height.equalTo(48)
        }
        
        addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.7 : 1.0
            }
        }
    }
}

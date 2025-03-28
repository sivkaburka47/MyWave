//
//  CustomLargeButton.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 25.02.2025.
//

import UIKit

final class CustomLargeButton: UIButton {
    
    enum ButtonStyle {
        case white
    }
    
    private var buttonStyle: ButtonStyle
    
    init(style: ButtonStyle) {
        self.buttonStyle = style
        super.init(frame: .zero)
        setupButton()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        self.buttonStyle = .white
        super.init(coder: coder)
        setupButton()
        configureStyle()
    }
    
    private func setupButton() {
        layer.cornerRadius = 28
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "VelaSans-Medium", size: 16)
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }
    
    private func configureStyle() {
        switch buttonStyle {
        case .white:
            backgroundColor = .white
            setTitleColor(.black, for: .normal)
            isUserInteractionEnabled = true
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateButtonAppearance(for: isHighlighted)
        }
    }
    
    private func updateButtonAppearance(for highlighted: Bool) {
        let targetAlpha: CGFloat = highlighted ? 0.7 : 1.0
        UIView.animate(withDuration: 0.1) {
            self.alpha = targetAlpha
        }
    }
    
    func getCurrentStyle() -> ButtonStyle {
        return self.buttonStyle
    }
    
    func toggleStyle(_ style: ButtonStyle) {
        buttonStyle = style
        configureStyle()
    }
}

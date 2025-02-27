//
//  ReminderView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 27.02.2025.
//

import UIKit
import SnapKit


class ReminderView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "EmotionViewBG")
        view.layer.cornerRadius = 32
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24

        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        if let image = UIImage(named: "deleteIcon")?.withConfiguration(config) {
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        return button
    }()
    
    var buttonAction: (() -> Void)?
    
    init(time: String, action: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.buttonAction = action
        setupUI()
        configure(time: time)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(deleteButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(64)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(18)
        }
        
        deleteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    private func configure(time: String) {
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(NSAttributedString(
            string: time,
            attributes: [
                .font: UIFont(name: "VelaSans-Regular", size: 20)!,
                .foregroundColor: UIColor.white
            ]
        ))
        
        contentLabel.attributedText = attributedText
        
        containerView.backgroundColor = UIColor(named: "EmotionViewBG") 
        deleteButton.tintColor = UIColor.white
        deleteButton.backgroundColor = UIColor(named: "grayGrad")
        deleteButton.isUserInteractionEnabled = true
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}



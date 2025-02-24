//
//  EmotionSelectionView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 24.02.2025.
//

import UIKit
import SnapKit

enum EmotionSelectionState {
    case inactive
    case active
}

class EmotionSelectionView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "EmotionViewBG")
        view.layer.cornerRadius = 40
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 32
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let image = UIImage(systemName: "arrow.right", withConfiguration: config)
        button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    private var buttonAction: (() -> Void)?
    
    init(state: EmotionSelectionState, emotion: String?, advice: String?, action: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.buttonAction = action
        setupUI()
        configure(state: state, emotion: emotion, advice: advice)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(arrowButton)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(80)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(64)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(arrowButton.snp.leading).offset(-16)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        arrowButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(state: EmotionSelectionState, emotion: String?, advice: String?) {
        switch state {
        case .inactive:
            configureInactiveState()
        case .active:
            configureActiveState(emotion: emotion, advice: advice)
        }
    }
    
    private func configureInactiveState() {
        let description = "Выберите эмоцию, лучше всего описывающую, что вы сейчас чувствуете"
        
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(NSAttributedString(
            string: description,
            attributes: [
                .font: UIFont(name: "VelaSans-Regular", size: 12)!,
                .foregroundColor: UIColor.white
            ]
        ))
        
        contentLabel.attributedText = attributedText
        
        containerView.backgroundColor = UIColor(named: "EmotionViewBG")
        arrowButton.backgroundColor = UIColor(named: "grayGrad")
        arrowButton.tintColor = .white
        arrowButton.isUserInteractionEnabled = false
    }
    
    private func configureActiveState(emotion: String?, advice: String?) {
        guard let emotion = emotion, let advice = advice else { return }
        
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(NSAttributedString(
            string: "\(emotion)\n",
            attributes: [
                .font: UIFont(name: "VelaSans-Bold", size: 12)!,
                .foregroundColor: UIColor(named: "cusBlue") ?? .systemBlue
            ]
        ))
        
        attributedText.append(NSAttributedString(
            string: advice,
            attributes: [
                .font: UIFont(name: "VelaSans-Regular", size: 12)!,
                .foregroundColor: UIColor.white
            ]
        ))
        
        contentLabel.attributedText = attributedText
        
        containerView.backgroundColor = UIColor(named: "EmotionViewBG")
        arrowButton.backgroundColor = .white
        arrowButton.tintColor = .black
        arrowButton.isUserInteractionEnabled = true
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}


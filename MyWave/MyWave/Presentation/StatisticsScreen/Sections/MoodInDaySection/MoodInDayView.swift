//
//  MoodInDayView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 01.03.2025.
//

import UIKit
import SnapKit

final class MoodInDayView: UIView {
    private let colors: [[UIColor]] = [
        [UIColor(named: "gradGreenStart")!, UIColor(named: "gradGreenEnd")!],
        [UIColor(named: "gradYellowStart")!, UIColor(named: "gradYellowEnd")!],
        [UIColor(named: "gradBlueStart")!, UIColor(named: "gradBlueEnd")!],
        [UIColor(named: "gradRedStart")!, UIColor(named: "gradRedEnd")!]
    ]
    private let titleLabel = UILabel()
    private let mainStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        setupTitleLabel()
        setupMainStack()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Ваше настроение в течение дня"
        titleLabel.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupMainStack() {
        mainStack.axis = .horizontal
        mainStack.distribution = .fillEqually
        mainStack.spacing = 8
        addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    func update(with entries: [MoodEntry]) {
        mainStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let sampleLabel = UILabel()
        sampleLabel.text = "100%"
        sampleLabel.sizeToFit()
        let minHeight = sampleLabel.frame.height

        for entry in entries {
            let partContainer = UIView()
            
            let emotionsContainer = UIStackView()
            emotionsContainer.axis = .vertical
            emotionsContainer.spacing = 4
            emotionsContainer.distribution = .fill
            emotionsContainer.layer.cornerRadius = 8
            emotionsContainer.layer.masksToBounds = true
            
            let textStack = UIStackView()
            textStack.axis = .vertical
            textStack.spacing = 4
            textStack.alignment = .center
            
            let partOfDayLabel = UILabel()
            partOfDayLabel.font = UIFont(name: "VelaSans-Regular", size: 14)
            partOfDayLabel.numberOfLines = 0
            partOfDayLabel.textAlignment = .center
            partOfDayLabel.textColor = .white
            partOfDayLabel.text = entry.partOfDay.text
            
            let countLabel = UILabel()
            countLabel.font = UIFont(name: "VelaSans-Regular", size: 12)
            countLabel.textColor = UIColor(named: "unactiveGray")
            countLabel.text = "\(entry.emotions.reduce(0) { $0 + $1.count })"
            
            textStack.addArrangedSubview(partOfDayLabel)
            textStack.addArrangedSubview(countLabel)
            
            partContainer.addSubview(emotionsContainer)
            partContainer.addSubview(textStack)
            
            emotionsContainer.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(partContainer).multipliedBy(0.85)
            }
            
            textStack.snp.makeConstraints {
                $0.top.equalTo(emotionsContainer.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview()
            }
            
            let groupedEmotions = Dictionary(
                grouping: entry.emotions,
                by: { $0.type }
            ).mapValues { $0.reduce(0) { $0 + $1.count } }
            
            let total = groupedEmotions.values.reduce(0, +)
            
            if total == 0 {
                emotionsContainer.backgroundColor = UIColor(named: "EmotionViewBG")
            } else {
                emotionsContainer.backgroundColor = .clear
                let sortedEmotions = EmotionType.allCases.compactMap { type -> (EmotionType, Int)? in
                    guard let count = groupedEmotions[type], count > 0 else { return nil }
                    return (type, count)
                }
                
                let proportions = sortedEmotions.map { CGFloat($0.1) / CGFloat(total) }
                
                for (index, (type, count)) in sortedEmotions.enumerated() {
                    let container = UIView()
                    let gradientView = GradientView()
                    let percentLabel = UILabel()
                    
                    container.layer.cornerRadius = 8
                    container.layer.masksToBounds = true
                    
                    gradientView.colors = colors[type.index]
                    percentLabel.text = String(format: "%.0f%%", proportions[index] * 100)
                    percentLabel.textColor = .black
                    percentLabel.font = UIFont(name: "VelaSans-Bold", size: 12)
                    percentLabel.textAlignment = .center
                    
                    container.addSubview(gradientView)
                    container.addSubview(percentLabel)
                    
                    gradientView.snp.makeConstraints { $0.edges.equalToSuperview() }
                    percentLabel.snp.makeConstraints { $0.center.equalToSuperview() }
                    
                    emotionsContainer.addArrangedSubview(container)
                    
                    container.snp.makeConstraints {
                        $0.height.greaterThanOrEqualTo(minHeight)
                        $0.height.equalTo(emotionsContainer.snp.height)
                            .multipliedBy(proportions[index])
                            .priority(.medium)
                    }
                }
            }
            
            mainStack.addArrangedSubview(partContainer)
        }
    }
}


private class GradientView: UIView {
    var colors: [UIColor] = [] {
        didSet { updateGradient() }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}

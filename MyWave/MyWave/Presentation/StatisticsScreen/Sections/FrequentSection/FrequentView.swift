//
//  FrequentView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 01.03.2025.
//

import UIKit
import SnapKit

final class FrequentView: UIView {
    private let colors: [[UIColor]] = [
        [UIColor(named: "gradGreenStart")!, UIColor(named: "gradGreenEnd")!],
        [UIColor(named: "gradYellowStart")!, UIColor(named: "gradYellowEnd")!],
        [UIColor(named: "gradBlueStart")!, UIColor(named: "gradBlueEnd")!],
        [UIColor(named: "gradRedStart")!, UIColor(named: "gradRedEnd")!]
    ]
    
    private let titleScreen = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        titleScreen.text = "Самые частые эмоции"
        titleScreen.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        titleScreen.textColor = .white
        titleScreen.numberOfLines = 0
        addSubview(titleScreen)
        
        titleScreen.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleScreen.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func update(with emotions: [EmotionFrequency]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let maxTitleWidth = calculateMaxTitleWidth(emotions: emotions)
        let maxCount = emotions.map { $0.count }.max() ?? 1
        
        emotions.forEach { emotion in
            let cell = createEmotionCell(
                emotion: emotion,
                maxTitleWidth: maxTitleWidth,
                maxCount: maxCount
            )
            stackView.addArrangedSubview(cell)
        }
        
        self.layoutIfNeeded()
    }
    
    private func calculateMaxTitleWidth(emotions: [EmotionFrequency]) -> CGFloat {
        let tempLabel = UILabel()
        tempLabel.font = UIFont(name: "VelaSans-Regular", size: 16)
        
        return emotions.map {
            tempLabel.text = $0.title
            return tempLabel.intrinsicContentSize.width
        }.max() ?? 0
    }
    
    private func createEmotionCell(emotion: EmotionFrequency, maxTitleWidth: CGFloat, maxCount: Int) -> UIView {
        let cell = UIView()
        
        let iconView = UIImageView(image: UIImage(named: emotion.icon))
        iconView.contentMode = .scaleAspectFit
        cell.addSubview(iconView)
        
        iconView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = emotion.title
        titleLabel.font = UIFont(name: "VelaSans-Regular", size: 16)
        titleLabel.textColor = .white
        cell.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(8)
            $0.centerY.equalTo(iconView)
            $0.width.equalTo(maxTitleWidth)
        }
        
        let progressContainer = UIView()
        progressContainer.backgroundColor = .clear
        progressContainer.layer.cornerRadius = 16
        cell.addSubview(progressContainer)
        
        progressContainer.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(iconView)
            $0.height.equalTo(32)
        }
        
        let progressBar = UIView()
        progressBar.layer.cornerRadius = 16
        progressContainer.addSubview(progressBar)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 16
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        
        let colorIndex: Int
        switch emotion.emotion {
        case .green: colorIndex = 0
        case .yellow: colorIndex = 1
        case .blue: colorIndex = 2
        case .red: colorIndex = 3
        }
        gradientLayer.colors = colors[colorIndex].map { $0.cgColor }
        progressBar.layer.insertSublayer(gradientLayer, at: 0)
        
        let countLabel = UILabel()
        countLabel.text = "\(emotion.count)"
        countLabel.font = UIFont(name: "VelaSans-Bold", size: 14)
        countLabel.textColor = .black
        progressBar.addSubview(countLabel)
        
        countLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.bottom.equalToSuperview().inset(7)
        }
        
        let countSize = countLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let countWidth = countSize.width + 32
        
        progressBar.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            
            $0.width.equalTo(progressContainer.snp.width)
                .multipliedBy(CGFloat(emotion.count) / CGFloat(maxCount))
                .priority(.medium)
            
            $0.width.greaterThanOrEqualTo(countWidth)
                .priority(.required)
        }
        
        progressBar.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        DispatchQueue.main.async {
            gradientLayer.frame = progressBar.bounds
        }
        
        cell.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        return cell
    }
}

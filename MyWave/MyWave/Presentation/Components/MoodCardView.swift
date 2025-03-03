//
//  MoodCardView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

final class MoodCardView: UIView {
    var type: CardType = .blue {
        didSet {
            updateGradient()
            updateImage()
        }
    }

    private let gradientLayer = CAGradientLayer()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor(named: "blackGrad")
        
        gradientLayer.type = .axial
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(60)
        }
        
        updateGradient()
        updateImage()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func updateGradient() {
        gradientLayer.colors = type.gradientColors.map { $0.cgColor }
    }

    private func updateImage() {
        imageView.image = UIImage(named: type.imageName)
    }
}

// MARK: - CardType
enum CardType {
    case blue
    case green
    case yellow
    case red

    var gradientColors: [UIColor] {
        switch self {
        case .blue:
            return [
                UIColor(named: "cardBlue")!.withAlphaComponent(0.3),
                UIColor(named: "cardBlue")!.withAlphaComponent(0.0)
            ]
        case .green:
            return [
                UIColor(named: "cardGreen")!.withAlphaComponent(0.3),
                UIColor(named: "cardGreen")!.withAlphaComponent(0.0)
            ]
        case .yellow:
            return [
                UIColor(named: "cardYellow")!.withAlphaComponent(0.3),
                UIColor(named: "cardYellow")!.withAlphaComponent(0.0)
            ]
        case .red:
            return [
                UIColor(named: "cardRed")!.withAlphaComponent(0.3),
                UIColor(named: "cardRed")!.withAlphaComponent(0.0)
            ]
        }
    }

    var imageName: String {
        switch self {
        case .blue:
            return "blueCardImage"
        case .green:
            return "greenCardImage"
        case .yellow:
            return "yellowCardImage"
        case .red:
            return "redCardImage"
        }
    }
    
    var emotionTextColor: UIColor {
        switch self {
        case .blue:
            return UIColor(named: "cusBlue") ?? .systemBlue
        case .green:
            return UIColor(named: "cusGreen") ?? .systemGreen
        case .yellow:
            return UIColor(named: "cusYellow") ?? .systemYellow
        case .red:
            return UIColor(named: "cusRed") ?? .systemRed
        }
    }
    
    var strokeGradient: [UIColor] {
        switch self {
        case .blue:
            return [UIColor(named: "gradBlueStart")!, UIColor(named: "gradBlueEnd")!]
        case .green:
            return [UIColor(named: "gradGreenStart")!, UIColor(named: "gradGreenEnd")!]
        case .yellow:
            return [UIColor(named: "gradYellowStart")!, UIColor(named: "gradYellowEnd")!]
        case .red:
            return [UIColor(named: "gradRedStart")!, UIColor(named: "gradRedEnd")!]
        }
    }
    
}

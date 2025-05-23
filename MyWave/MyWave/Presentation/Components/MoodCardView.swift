//
//  MoodCardView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

final class MoodCardView: UIView {
    var noteId: String?

    var type: CardType = .blue {
        didSet {
            updateGradient()
        }
    }

    var icon: String = "" {
        didSet {
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
        imageView.image = UIImage(named: icon)
    }
}

//
//  CircularProgressView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import UIKit

final class CircularProgressView: UIView {
    private let backgroundLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let progressLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundLayer.strokeColor = UIColor(named: "blackGrad")!.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 24
        layer.addSublayer(backgroundLayer)
        
        gradientLayer.colors = [
            UIColor(named: "blackGrad")!.withAlphaComponent(0).cgColor,
            UIColor(named: "blackGrad")!.cgColor,
            UIColor(named: "grayGrad")!.cgColor,
            UIColor(named: "grayGrad")!.cgColor
        ]
        gradientLayer.locations = [0.0857, 0.351, 0.9756, 1.0] as [NSNumber]
        gradientLayer.type = .axial
        
        let angle: CGFloat = 79.72 * .pi / 180
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: cos(angle), y: sin(angle))
        layer.addSublayer(gradientLayer)
        
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 24
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0.5
        gradientLayer.mask = progressLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height)/2 - backgroundLayer.lineWidth/2
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi/2,
            endAngle: 3 * .pi/2,
            clockwise: true
        )
        
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        gradientLayer.frame = bounds
        
        startRotationAnimation()
    }
    
    private func startRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 4
        rotation.repeatCount = .infinity
        gradientLayer.add(rotation, forKey: "rotation")
    }
}

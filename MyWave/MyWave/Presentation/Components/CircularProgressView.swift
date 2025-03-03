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
    
    private var segmentLayers: [CALayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    func update(with entries: [CardType]) {
        segmentLayers.forEach { $0.removeFromSuperlayer() }
        segmentLayers.removeAll()
        
        gradientLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        
        if entries.isEmpty {
            backgroundLayer.isHidden = false
            layer.addSublayer(gradientLayer)
            gradientLayer.mask = progressLayer
            startRotationAnimation()
        } else {
            backgroundLayer.isHidden = false
            let path = createPath()
            
            let groupedEntries = Dictionary(grouping: entries) { $0.strokeGradient }
            let total = CGFloat(entries.count)
            
            var currentStart: CGFloat = 0
            
            for (_, group) in groupedEntries {
                let proportion = CGFloat(group.count) / total
                let strokeEnd = currentStart + proportion
                
                let gradientLayer = createGradientLayer(
                    for: group[0],
                    path: path,
                    strokeStart: currentStart,
                    strokeEnd: strokeEnd
                )
                
                layer.addSublayer(gradientLayer)
                segmentLayers.append(gradientLayer)
                
                currentStart = strokeEnd
            }
        }
    }

    
    private func createPath() -> UIBezierPath {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height)/2 - backgroundLayer.lineWidth/2
        return UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi/2,
            endAngle: 3 * .pi/2,
            clockwise: true
        )
    }
    
    private func createGradientLayer(for entry: CardType, path: UIBezierPath, strokeStart: CGFloat, strokeEnd: CGFloat, round: Bool = false) -> CALayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = entry.strokeGradient.map { $0.cgColor }
        gradientLayer.frame = bounds
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.lineWidth = 24
        if round {
            maskLayer.lineCap = .round
        }
        maskLayer.strokeStart = strokeStart
        maskLayer.strokeEnd = strokeEnd
        gradientLayer.mask = maskLayer
        
        updateGradientPoints(gradientLayer, strokeStart: strokeStart, strokeEnd: strokeEnd)
        
        return gradientLayer
    }
    
    private func updateGradientPoints(_ gradientLayer: CAGradientLayer, strokeStart: CGFloat, strokeEnd: CGFloat) {
        let startAngle = -CGFloat.pi/2 + strokeStart * 2 * .pi
        let endAngle = -CGFloat.pi/2 + strokeEnd * 2 * .pi
        
        gradientLayer.startPoint = CGPoint(
            x: 0.5 + 0.5 * cos(startAngle),
            y: 0.5 + 0.5 * sin(startAngle)
        )
        gradientLayer.endPoint = CGPoint(
            x: 0.5 + 0.5 * cos(endAngle),
            y: 0.5 + 0.5 * sin(endAngle)
        )
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
        
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 24
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = createPath()
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        gradientLayer.frame = bounds
        
        segmentLayers.forEach { layer in
            layer.frame = bounds
            if let gradientLayer = layer as? CAGradientLayer,
               let maskLayer = gradientLayer.mask as? CAShapeLayer {
                maskLayer.path = path.cgPath
                updateGradientPoints(gradientLayer, strokeStart: maskLayer.strokeStart, strokeEnd: maskLayer.strokeEnd)
            }

        }
    }
    
    private var isAnimating = false
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil && isAnimating {
            startRotationAnimation()
        }
    }
    
    private func startRotationAnimation() {
        gradientLayer.removeAnimation(forKey: "rotation")
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 4
        rotation.repeatCount = .infinity
        rotation.isRemovedOnCompletion = false
        gradientLayer.add(rotation, forKey: "rotation")
        
        isAnimating = true
    }
    
    func pauseAnimation() {
        let pausedTime = gradientLayer.convertTime(CACurrentMediaTime(), from: nil)
        gradientLayer.speed = 0.0
        gradientLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = gradientLayer.timeOffset
        gradientLayer.speed = 1.0
        gradientLayer.timeOffset = 0.0
        gradientLayer.beginTime = 0.0
        let timeSincePause = gradientLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        gradientLayer.beginTime = timeSincePause
    }
}

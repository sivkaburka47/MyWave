//
//  AnimatedGradientView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import UIKit

class AnimatedGradientView: UIView {
    private let circleSize: CGFloat
    private var circles: [UIView] = []
    private let colors: [UIColor?] = [UIColor(named: "GradientCircleThree"), UIColor(named: "GradientCircleTwo"), UIColor(named: "GradientCircleOne"), UIColor(named: "GradientCircleFour")]
    private let animationDuration: TimeInterval = 14
    
    init(frame: CGRect, circleSize: CGFloat) {
        self.circleSize = circleSize * 1.5
        super.init(frame: frame)
        setupCircles()
        setupBlurEffect()
        startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCircles() {
        for color in colors {
            let circle = UIView()
            circle.backgroundColor = color
            circle.alpha = 0.5
            circle.layer.cornerRadius = circleSize / 2
            circle.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
            
            applyGradientMask(to: circle)
            circle.layer.compositingFilter = "overlayBlendMode"
            addSubview(circle)
            circles.append(circle)
        }
    }
    
    private func applyGradientMask(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(1.0).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        gradientLayer.locations = [1.0, 0.8, 0.6, 0.3, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let maskView = UIView(frame: view.bounds)
        maskView.layer.addSublayer(gradientLayer)
        view.mask = maskView
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    
    private func startAnimation() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 3
        let steps = 14
        
        var circularPositions: [[CGPoint]] = []
        for i in 0..<4 {
            var positions: [CGPoint] = []
            for step in 0...steps {
                let angle = CGFloat(step) * (2 * .pi / CGFloat(steps)) + CGFloat(i) * (.pi / 2)
                let x = center.x + radius * cos(angle)
                let y = center.y + radius * sin(angle)
                positions.append(CGPoint(x: x, y: y))
            }
            circularPositions.append(positions)
        }
        
        for (index, circle) in circles.enumerated() {
            circle.center = circularPositions[index][0]
        }
        
        animateCircles(positions: circularPositions)
    }
    
    private func animateCircles(positions: [[CGPoint]]) {
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [.repeat, .calculationModeLinear, .allowUserInteraction]) {
            for (index, circle) in self.circles.enumerated() {
                for step in 0..<positions[index].count {
                    UIView.addKeyframe(
                        withRelativeStartTime: Double(step) / Double(positions[index].count),
                        relativeDuration: 1.0 / Double(positions[index].count)
                    ) {
                        circle.center = positions[index][step]
                    }
                }
            }
        }
    }

}


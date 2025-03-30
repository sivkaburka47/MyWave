//
//  EmotionCirclesView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 02.03.2025.
//

import UIKit
import SnapKit

class EmotionCirclesView: UIView {
    private let colors: [[UIColor]] = [
        [UIColor(named: "gradGreenStart")!, UIColor(named: "gradGreenEnd")!],
        [UIColor(named: "gradYellowStart")!, UIColor(named: "gradYellowEnd")!],
        [UIColor(named: "gradBlueStart")!, UIColor(named: "gradBlueEnd")!],
        [UIColor(named: "gradRedStart")!, UIColor(named: "gradRedEnd")!]
    ]
    
    private var textAttributes: [NSAttributedString.Key: Any] = {
        let font = UIFont(name: "VelaSans-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return [
            .font: font,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
    }()
    
    var percentages: [(value: Float, type: EmotionType)] = [] {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.clear.set()
        UIRectFill(rect)
        
        guard !percentages.isEmpty else { return }
        
        if percentages.count == 1 {
            drawSingleCircle()
        } else {
            let sorted = percentages.enumerated()
                .sorted { $0.element.value > $1.element.value }
            
            if let (minDiffIndex, _) = findMinDiffIndices(in: sorted) {
                let arranged = arrangeElements(sorted: sorted, minDiffIndex: minDiffIndex)
                drawCircles(arranged: arranged)
            } else {
                drawCircles(arranged: sorted.map { $0 })
            }
        }
    }
    
    private func drawSingleCircle() {
        guard let element = percentages.first else { return }
        let percent = element.value
        guard percent > 0 else { return }
        
        let radius = min(bounds.width, bounds.height) * 0.8 / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        if let context = UIGraphicsGetCurrentContext() {
            drawGradientCircle(
                context: context,
                center: center,
                radius: radius,
                emotionType: element.type
            )
            
            drawText(
                text: "\(Int(percent))%",
                center: center
            )
        }
    }
    
    
    private func findMinDiffIndices(in sorted: [EnumeratedSequence<[(value: Float, type: EmotionType)]>.Element]) -> (Int, Int)? {
        guard sorted.count >= 1 else { return nil }
        return sorted.count == 1 ? (0, 0) : {
            var minDiff = Float.greatestFiniteMagnitude
            var minIndex = 0
            for i in 0..<sorted.count-1 {
                let diff = abs(sorted[i].element.value - sorted[i+1].element.value)
                if diff < minDiff {
                    minDiff = diff
                    minIndex = i
                }
            }
            return (minIndex, minIndex + 1)
        }()
    }
    
    private func arrangeElements(
        sorted: [EnumeratedSequence<[(value: Float, type: EmotionType)]>.Element],
        minDiffIndex: Int
    ) -> [EnumeratedSequence<[(value: Float, type: EmotionType)]>.Element] {
        var arranged = [EnumeratedSequence<[(value: Float, type: EmotionType)]>.Element]()
        
        arranged.append(sorted[minDiffIndex])
        arranged.append(sorted[minDiffIndex + 1])
        
        sorted.enumerated().forEach { index, element in
            if index != minDiffIndex && index != minDiffIndex + 1 {
                arranged.append(element)
            }
        }
        return arranged
    }
    
    private func drawCircles(arranged: [EnumeratedSequence<[(value: Float, type: EmotionType)]>.Element]) {
        let maxRadius = bounds.width / 2
        let minRadius: CGFloat = 20
        
        let positions = [
            CGPoint(x: bounds.width, y: 0),
            CGPoint(x: 0, y: bounds.height),
            CGPoint(x: 0, y: 0),
            CGPoint(x: bounds.width, y: bounds.height)
        ]
        
        for (index, element) in arranged.enumerated() {
            guard index < positions.count else { break }
            let percent = element.element.value
            guard percent > 0 else { continue }
            
            let position = positions[index]
            let rawRadius = bounds.width * CGFloat(percent / 100) * 0.7
            let radius = max(minRadius, min(maxRadius, rawRadius))
            
            let center = CGPoint(
                x: position.x == 0 ? radius : bounds.width - radius,
                y: position.y == 0 ? radius : bounds.height - radius
            )
            
            if let context = UIGraphicsGetCurrentContext() {
                drawGradientCircle(
                    context: context,
                    center: center,
                    radius: radius,
                    emotionType: element.element.type
                )
                
                drawText(
                    text: "\(Int(percent))%",
                    center: center
                )
            }
        }
    }
    
    private func drawGradientCircle(
        context: CGContext,
        center: CGPoint,
        radius: CGFloat,
        emotionType: EmotionType
    ) {
        let colorIndex: Int
        switch emotionType {
        case .green: colorIndex = 0
        case .yellow: colorIndex = 1
        case .blue: colorIndex = 2
        case .red: colorIndex = 3
        }
        
        let colors = self.colors[colorIndex].map { $0.cgColor }
        guard let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: [0, 1]
        ) else { return }
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.saveGState()
        path.addClip()
        
        let startPoint = CGPoint(x: center.x - radius, y: center.y - radius)
        let endPoint = CGPoint(x: center.x + radius, y: center.y + radius)
        
        context.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: []
        )
        context.restoreGState()
    }
    
    private func drawText(text: String, center: CGPoint) {
        let textSize = NSString(string: text).size(withAttributes: textAttributes)
        let radius = hypot(textSize.width, textSize.height) / 2
        guard radius <= center.x && radius <= center.y else { return }
        
        let textRect = CGRect(
            x: center.x - textSize.width/2,
            y: center.y - textSize.height/2,
            width: textSize.width,
            height: textSize.height
        )
        
        NSString(string: text).draw(in: textRect, withAttributes: textAttributes)
    }
}


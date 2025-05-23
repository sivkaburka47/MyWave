//
//  CardType.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation
import UIKit

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

extension CardType {
    init(emotionType: EmotionType) {
        switch emotionType {
        case .blue:
            self = .blue
        case .green:
            self = .green
        case .yellow:
            self = .yellow
        case .red:
            self = .red
        }
    }
}

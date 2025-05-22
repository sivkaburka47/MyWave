//
//  Note.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 02.03.2025.
//

import Foundation
import UIKit

struct Note: Identifiable {
    let id: String
    let title: String
    let type: EmotionType
    let icon: String
    let dateAdded: Date
}

enum EmotionType: String, CaseIterable, Hashable  {
    case green = "green"
    case yellow = "yellow"
    case blue = "blue"
    case red = "red"
}

extension EmotionType {
    var index: Int {
        switch self {
        case .green: 0
        case .yellow: 1
        case .blue: 2
        case .red: 3
        }
    }

    var gradientColor: [UIColor] {
        let colors: [[UIColor]] = [
            [UIColor(named: "gradGreenStart")!, UIColor(named: "gradGreenEnd")!],
            [UIColor(named: "gradYellowStart")!, UIColor(named: "gradYellowEnd")!],
            [UIColor(named: "gradBlueStart")!, UIColor(named: "gradBlueEnd")!],
            [UIColor(named: "gradRedStart")!, UIColor(named: "gradRedEnd")!]
        ]
        return colors[index]
    }
}

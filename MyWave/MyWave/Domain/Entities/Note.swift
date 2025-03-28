//
//  Note.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 02.03.2025.
//

import Foundation

struct Note {
    let title: String
    let type: EmotionType
    let icon: String
    let dateAdded: Date
}

enum EmotionType:  String, CaseIterable, Hashable  {
    case green
    case yellow
    case blue
    case red
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
}

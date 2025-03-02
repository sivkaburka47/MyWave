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


enum EmotionType {
    case green
    case yellow
    case blue
    case red
}

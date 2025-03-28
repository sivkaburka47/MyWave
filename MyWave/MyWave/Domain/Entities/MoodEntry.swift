//
//  MoodEntry.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 03.03.2025.
//

import Foundation

struct MoodEntry {
    let partOfDay: PartOfDay
    let emotions: [(type: EmotionType, count: Int)]
}

enum PartOfDay {
    case earlyMorning
    case morning
    case day
    case evening
    case lateEvening
}

extension PartOfDay {
    var text: String {
        switch self {
        case .earlyMorning: "Раннее утро"
        case .morning: "Утро"
        case .day: "День"
        case .evening: "Вечер"
        case .lateEvening: "Поздний вечер"
        }
    }
}


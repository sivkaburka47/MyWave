//
//  PartOfDay.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

enum PartOfDay: Int, CaseIterable, Comparable {
    case earlyMorning = 0
    case morning
    case day
    case evening
    case lateEvening

    static func < (lhs: PartOfDay, rhs: PartOfDay) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var text: String {
        switch self {
        case .earlyMorning: return "Раннее утро"
        case .morning: return "Утро"
        case .day: return "День"
        case .evening: return "Вечер"
        case .lateEvening: return "Поздний вечер"
        }
    }

    var hourRange: Range<Int> {
        switch self {
        case .earlyMorning: return 5..<8
        case .morning: return 8..<12
        case .day: return 12..<17
        case .evening: return 17..<21
        case .lateEvening: return 0..<5
        }
    }

    static func from(date: Date) -> PartOfDay {
        let hour = Calendar.current.component(.hour, from: date)

        if (21..<24).contains(hour) || (0..<5).contains(hour) {
            return .lateEvening
        }

        return Self.allCases.first(where: { $0.hourRange.contains(hour) }) ?? .day
    }
}

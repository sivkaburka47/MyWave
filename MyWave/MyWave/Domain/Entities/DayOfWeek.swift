//
//  DayOfWeek.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

enum DayOfWeek: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    func localizedLabel() -> String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }

    static func fromCalendarWeekday(_ calendarWeekday: Int) -> DayOfWeek? {
        switch calendarWeekday {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        case 1: return .sunday
        default: return nil
        }
    }
}

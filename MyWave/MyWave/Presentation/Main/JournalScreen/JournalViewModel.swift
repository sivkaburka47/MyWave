//
//  JournalViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation

protocol JournalViewModelProtocol {
    func startAddNoteFlow()
    func editNote()
}

final class JournalViewModel: JournalViewModelProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: JournalCoordinator?
    
    let demoEntries: [[String: Any]] = [
        ["date": Date().addingTimeInterval(-500000), "emotion": "продуктивность", "type": CardType.yellow],
        ["date": Date().addingTimeInterval(-500000), "emotion": "продуктивность", "type": CardType.yellow],
        ["date": Date().addingTimeInterval(-500000), "emotion": "продуктивность", "type": CardType.green],
        ["date": Date().addingTimeInterval(-10000), "emotion": "беспокойство", "type": CardType.yellow],
        ["date": Date().addingTimeInterval(-400400), "emotion": "спокойствие", "type": CardType.green],
        ["date": Date().addingTimeInterval(-436400), "emotion": "выгорание", "type": CardType.blue],
        ["date": Date().addingTimeInterval(-600400), "emotion": "напряжение", "type": CardType.red]
    ]
    
    let minEntriesCount = 2
    let seriesDuration = 3
    
    var entriesCount: Int {
        demoEntries.count
    }
}

// MARK: - Public Methods

extension JournalViewModel {
    
    func entriesCountString() -> String {
        formatCount(entriesCount, singular: "запись", few: "записи", many: "записей")
    }
    
    func minEntriesCountString() -> String {
        formatCount(minEntriesCount, singular: "запись", few: "записи", many: "записей")
    }
    
    func seriesDurationString() -> String {
        formatCount(seriesDuration, singular: "день", few: "дня", many: "дней")
    }
    
    func getTodayEntries() -> [CardType] {
        demoEntries
            .filter { entry in
                guard let date = entry["date"] as? Date else { return false }
                return Calendar.current.isDateInToday(date)
            }
            .compactMap { $0["type"] as? CardType }
    }
    
    func startAddNoteFlow() {
        coordinator?.navigateToEmotionSelection()
    }
    
    func editNote() {
        coordinator?.navigateToAddNote()
    }
}

// MARK: - Private Helpers

extension JournalViewModel {
    
    private func formatCount(_ count: Int, singular: String, few: String, many: String) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) \(singular)"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            return "\(count) \(few)"
        } else {
            return "\(count) \(many)"
        }
    }
}

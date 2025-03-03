//
//  MainViewModel.swift
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
    weak var coordinator: JournalCoordinator?
    
    let demoEntries: [[String: Any]] = [
        [
            "date": Date().addingTimeInterval(-10000),
            "emotion": "продуктивность",
            "type": CardType.yellow
        ],
        [
            "date": Date().addingTimeInterval(-10000),
            "emotion": "продуктивность",
            "type": CardType.yellow
        ],
        [
            "date": Date().addingTimeInterval(-10000),
            "emotion": "продуктивность",
            "type": CardType.green
        ],
        [
            "date": Date().addingTimeInterval(-10000),
            "emotion": "беспокойство",
            "type": CardType.yellow
        ],
        [
            "date": Date().addingTimeInterval(-400400),
            "emotion": "спокойствие",
            "type": CardType.green
        ],
        [
            "date": Date().addingTimeInterval(-436400),
            "emotion": "выгорание",
            "type": CardType.blue
        ],
        [
            "date": Date().addingTimeInterval(-600400),
            "emotion": "напряжение",
            "type": CardType.red
        ],
    ]
    
    var entriesCount: Int {
        demoEntries.count
    }
    
    func entriesCountString() -> String {
        let remainder10 = entriesCount % 10
        let remainder100 = entriesCount % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(entriesCount) запись"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            return "\(entriesCount) записи"
        } else {
            return "\(entriesCount) записей"
        }
    }
    
    func getTodayEntries() -> [CardType] {
        let todayEntries = demoEntries.filter { entry in
            guard let date = entry["date"] as? Date else { return false }
            return Calendar.current.isDateInToday(date)
        }
        return todayEntries.compactMap { $0["type"] as? CardType }
    }
    
    
    
    func startAddNoteFlow() {
        coordinator?.navigateToEmotionSelection()
    }
    
    func editNote(){
        coordinator?.navigateToAddNote()
    }
}

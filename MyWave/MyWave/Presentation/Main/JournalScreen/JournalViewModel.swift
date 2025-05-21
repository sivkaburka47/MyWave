//
//  JournalViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation

protocol JournalViewModelProtocol {
    func startAddNoteFlow()
    func editNote(with id: String)
}

final class JournalViewModel: JournalViewModelProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: JournalCoordinator?
    private let localDataSource = LocalDataSource.shared

    var allNotes = [Note]()

    var onDidLoadAllNotes: (([Note]) -> Void)?

    let minEntriesCount = 2
    var seriesDuration = 0
    var entriesCount = 0

    init() {
    }

    func onDidLoad() {
        allNotes = localDataSource.getAllNotes()
        entriesCount = allNotes.count
        seriesDuration = calculateSeriesDuration()
        onDidLoadAllNotes?(allNotes)
    }

    private func addSampleNote() {
        let note = Note(
            id: UUID().uuidString,
            title: "New запись",
            type: .blue,
            icon: "blueCardImage",
            dateAdded: Date()
        )

        let noteDetails = NoteDetails(
            note: note,
            activities: ["Чтение", "Прогулка"],
            companions: ["Один"],
            locations: ["Парк"]
        )

        localDataSource.saveNoteDetails(noteDetails)
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
        allNotes
            .filter { Calendar.current.isDateInToday($0.dateAdded) }
            .map { CardType(emotionType: $0.type) }
    }
    
    func startAddNoteFlow() {
        coordinator?.navigateToEmotionSelection()
    }
    
    func editNote(with id: String) {
        coordinator?.navigateToEditNote(with: id)
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

    private func calculateSeriesDuration() -> Int {
        let calendar = Calendar.current

        let uniqueDates = Set(allNotes.map { calendar.startOfDay(for: $0.dateAdded) })

        guard !uniqueDates.isEmpty else { return 0 }

        let sortedDates = uniqueDates.sorted(by: >)

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        for date in sortedDates {
            if date == currentDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }

        return streak
    }

}

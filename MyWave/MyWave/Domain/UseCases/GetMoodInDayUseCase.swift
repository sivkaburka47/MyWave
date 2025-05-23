//
//  GetMoodInDayUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol GetMoodInDayUseCase {
    func execute(monday: Date) async -> [MoodEntry]
}

class GetMoodInDayUseCaseImpl: GetMoodInDayUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetMoodInDayUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetMoodInDayUseCaseImpl(repository: repository)
    }

    func execute(monday: Date) async -> [MoodEntry] {
        let notes = await repository.getWeekNotes(monday: monday)

        var moodCounts: [PartOfDay: [EmotionType: Int]] = [
            .earlyMorning: [:], .morning: [:], .day: [:], .evening: [:], .lateEvening: [:]
        ]

        for part in moodCounts.keys {
            moodCounts[part] = [.red: 0, .blue: 0, .yellow: 0, .green: 0]
        }

        for note in notes {
            let part = PartOfDay.from(date: note.dateAdded)
            moodCounts[part]?[note.type]! += 1
        }

        let orderedParts: [PartOfDay] = [.earlyMorning, .morning, .day, .evening, .lateEvening]

        return orderedParts.map { part in
            guard let counts = moodCounts[part] else {
                return MoodEntry(partOfDay: part, emotions: [])
            }
            let emotions = counts
                .filter { $0.value > 0 }
                .sorted { $0.key.rawValue < $1.key.rawValue }
                .map { (type: $0.key, count: $0.value) }
            return MoodEntry(partOfDay: part, emotions: emotions)
        }
    }
}

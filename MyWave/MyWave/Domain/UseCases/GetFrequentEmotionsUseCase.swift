//
//  GetFrequentEmotionsUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol GetFrequentEmotionsUseCase {
    func execute(monday: Date) -> [EmotionFrequency]
}

class GetFrequentEmotionsUseCaseImpl: GetFrequentEmotionsUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetFrequentEmotionsUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetFrequentEmotionsUseCaseImpl(repository: repository)
    }

    func execute(monday: Date) -> [EmotionFrequency] {
        let notes = repository.getWeekNotes(monday: monday)
        var frequencyDict: [EmotionKey: (count: Int, icon: String)] = [:]

        for note in notes {
            let key = EmotionKey(title: note.title, emotion: note.type)
            if let existing = frequencyDict[key] {
                frequencyDict[key] = (existing.count + 1, existing.icon)
            } else {
                frequencyDict[key] = (1, note.icon)
            }
        }

        let frequencies = frequencyDict.map { key, value in
            EmotionFrequency(title: key.title, emotion: key.emotion, icon: value.icon, count: value.count)
        }

        return Array(frequencies.sorted { $0.count > $1.count }.prefix(7))
    }
}

//
//  GetColoredCirclesUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol GetColoredCirclesUseCase {
    func execute(monday: Date) async -> [ColoredCircle]
}

class GetColoredCirclesUseCaseImpl: GetColoredCirclesUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetColoredCirclesUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetColoredCirclesUseCaseImpl(repository: repository)
    }

    func execute(monday: Date) async -> [ColoredCircle] {
        let notes = await repository.getWeekNotes(monday: monday)

        let countDict = notes.reduce(into: [EmotionType: Int]()) { counts, note in
            counts[note.type, default: 0] += 1
        }

        let total = Float(notes.count)
        guard total > 0 else { return [] }

        return countDict.map { (type, count) in
            ColoredCircle(type: type, percent: Float(count) / total * 100)
        }
    }
}

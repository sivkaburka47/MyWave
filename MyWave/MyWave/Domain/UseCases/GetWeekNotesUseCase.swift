//
//  GetWeekNotesUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol GetWeekNotesUseCase {
    func execute(monday: Date) async -> [Note]
}

class GetWeekNotesUseCaseImpl: GetWeekNotesUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetWeekNotesUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetWeekNotesUseCaseImpl(repository: repository)
    }

    func execute(monday: Date) async -> [Note] {
        return await repository.getWeekNotes(monday: monday)
    }
}

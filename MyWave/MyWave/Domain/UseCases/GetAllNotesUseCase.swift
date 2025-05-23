//
//  GetAllNotesUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 23.05.2025.
//

import Foundation

protocol GetAllNotesUseCase {
    func execute() -> [Note]
}

class GetAllNotesUseCaseImpl: GetAllNotesUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetAllNotesUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetAllNotesUseCaseImpl(repository: repository)
    }

    func execute() -> [Note] {
        let notes = repository.getAllNotes()
        return notes
    }
}

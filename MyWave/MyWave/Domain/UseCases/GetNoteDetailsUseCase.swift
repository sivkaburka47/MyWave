//
//  GetNoteDetailsUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 23.05.2025.
//

import Foundation

protocol GetNoteDetailsUseCase {
    func execute(id: String) -> NoteDetails?
}

class GetNoteDetailsUseCaseImpl: GetNoteDetailsUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetNoteDetailsUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetNoteDetailsUseCaseImpl(repository: repository)
    }

    func execute(id: String) -> NoteDetails? {
        let noteDetails = repository.getNoteDetails(id: id)
        return noteDetails
    }
}

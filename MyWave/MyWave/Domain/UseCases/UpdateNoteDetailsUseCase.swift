//
//  UpdateNoteDetailsUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 23.05.2025.
//

import Foundation

protocol UpdateNoteDetailsUseCase {
    func execute(noteDetails: NoteDetails)
}

class UpdateNoteDetailsUseCaseImpl: UpdateNoteDetailsUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> UpdateNoteDetailsUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return UpdateNoteDetailsUseCaseImpl(repository: repository)
    }

    func execute(noteDetails: NoteDetails) {
        repository.updateNoteDetails(noteDetails: noteDetails)
    }
}

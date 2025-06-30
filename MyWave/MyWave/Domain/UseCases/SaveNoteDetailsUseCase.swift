//
//  SaveNoteDetailsUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 23.05.2025.
//

import Foundation

protocol SaveNoteDetailsUseCase {
    func execute(noteDetails: NoteDetails) async
}

class SaveNoteDetailsUseCaseImpl: SaveNoteDetailsUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> SaveNoteDetailsUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return SaveNoteDetailsUseCaseImpl(repository: repository)
    }

    func execute(noteDetails: NoteDetails) async {
        await repository.saveNoteDetails(noteDetails: noteDetails)
    }
}

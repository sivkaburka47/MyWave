//
//  GetLatestNoteDateUseCase.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol GetLatestNoteDateUseCase {
    func execute() -> Date?
}

class GetLatestNoteDateUseCaseImpl: GetLatestNoteDateUseCase {
    private let repository: NotesRepository

    init(repository: NotesRepository) {
        self.repository = repository
    }

    static func create() -> GetLatestNoteDateUseCaseImpl {
        let dataSource = LocalDataSource.shared
        let repository = NotesRepositoryImpl(dataSource: dataSource)
        return GetLatestNoteDateUseCaseImpl(repository: repository)
    }

    func execute() -> Date? {
        let latestNoteDate = repository.getLatestNoteDate()
        return latestNoteDate
    }
}

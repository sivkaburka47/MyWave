//
//  NotesRepositoryImpl.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 23.05.2025.
//

import Foundation

class NotesRepositoryImpl: NotesRepository {
    private let dataSource: LocalDataSource

    init(dataSource: LocalDataSource) {
        self.dataSource = dataSource
    }

    func getWeekNotes(monday: Date) -> [Note] {
        let notes = dataSource.getWeekNotes(monday)
        return notes
    }

    func saveNoteDetails(noteDetails: NoteDetails) {
        dataSource.saveNoteDetails(noteDetails: noteDetails)
    }

    func updateNoteDetails(noteDetails: NoteDetails) {
        dataSource.updateNoteDetails(noteDetails: noteDetails)
    }

    func getNoteDetails(id: String) -> NoteDetails? {
        let noteDetails = dataSource.getNoteDetails(id: id)
        return noteDetails
    }

    func getAllNotes() -> [Note] {
        let notes = dataSource.getAllNotes()
        return notes
    }
    
    func getLatestNoteDate() -> Date? {
        let date = dataSource.getLatestNoteDate()
        return date
    }
}

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

    func getWeekNotes(monday: Date) async -> [Note] {
        return await dataSource.getWeekNotes(monday)
    }

    func saveNoteDetails(noteDetails: NoteDetails) async {
        await dataSource.saveNoteDetails(noteDetails: noteDetails)
    }

    func updateNoteDetails(noteDetails: NoteDetails) async {
        await dataSource.updateNoteDetails(noteDetails: noteDetails)
    }

    func getNoteDetails(id: String) async -> NoteDetails? {
        return await dataSource.getNoteDetails(id: id)
    }

    func getAllNotes() async -> [Note] {
        return await dataSource.getAllNotes()
    }
    
    func getLatestNoteDate() async -> Date? {
        return await dataSource.getLatestNoteDate()
    }
}

//
//  NotesRepository.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol NotesRepository {
    func saveNoteDetails(noteDetails: NoteDetails)
    func updateNoteDetails(noteDetails: NoteDetails)
    func getNoteDetails(id: String) -> NoteDetails?
    func getAllNotes() -> [Note]
    func getLatestNoteDate() -> Date?
    func getWeekNotes(monday: Date) -> [Note]
}

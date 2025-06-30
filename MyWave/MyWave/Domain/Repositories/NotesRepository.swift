//
//  NotesRepository.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.05.2025.
//

import Foundation

protocol NotesRepository {
    func saveNoteDetails(noteDetails: NoteDetails) async
    func updateNoteDetails(noteDetails: NoteDetails) async
    func getNoteDetails(id: String) async -> NoteDetails?
    func getAllNotes() async -> [Note]
    func getLatestNoteDate() async -> Date?
    func getWeekNotes(monday: Date) async -> [Note]
}

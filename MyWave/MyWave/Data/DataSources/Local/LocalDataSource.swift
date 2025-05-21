//
//  LocalDataSource.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 20.05.2025.
//

import CoreData

class LocalDataSource {
    static let shared = LocalDataSource()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreData")
        persistentContainer.loadPersistentStores { _, _ in }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

extension LocalDataSource {

    public func saveNoteDetails(_ noteDetails: NoteDetails) {
        let noteObject = NoteObject(context: context)

        noteObject.id = noteDetails.note.id
        noteObject.title = noteDetails.note.title
        noteObject.emotionType = noteDetails.note.type.rawValue
        noteObject.icon = noteDetails.note.icon
        noteObject.dateAdded = noteDetails.note.dateAdded
        noteObject.activities = noteDetails.activities
        noteObject.companions = noteDetails.companions
        noteObject.locations = noteDetails.locations

        saveContext()
    }

    public func updateNoteDetails(_ noteDetails: NoteDetails) {
        let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")
        fetchRequest.predicate = NSPredicate(format: "id == %@", noteDetails.note.id)
        fetchRequest.fetchLimit = 1

        do {
            if let noteObject = try context.fetch(fetchRequest).first {
                noteObject.title = noteDetails.note.title
                noteObject.emotionType = noteDetails.note.type.rawValue
                noteObject.icon = noteDetails.note.icon
                noteObject.dateAdded = noteDetails.note.dateAdded
                noteObject.activities = noteDetails.activities
                noteObject.companions = noteDetails.companions
                noteObject.locations = noteDetails.locations

                saveContext()
            } else {
                print("Note with id \(noteDetails.note.id) not found.")
            }
        } catch {
            print("Failed to update note: \(error)")
        }
    }


    public func getNoteDetails(by id: String) -> NoteDetails? {
        let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        guard let noteObject = try? context.fetch(fetchRequest).first else {
            return nil
        }

        let note = Note(
            id: noteObject.id,
            title: noteObject.title,
            type: EmotionType(rawValue: noteObject.emotionType) ?? .green,
            icon: noteObject.icon,
            dateAdded: noteObject.dateAdded
        )

        return NoteDetails(
            note: note,
            activities: noteObject.activities,
            companions: noteObject.companions,
            locations: noteObject.locations
        )
    }

    public func getAllNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")

        do {
            let noteObjects = try context.fetch(fetchRequest)

            return noteObjects.map { noteObject in
                Note(
                    id: noteObject.id,
                    title: noteObject.title,
                    type: EmotionType(rawValue: noteObject.emotionType) ?? .green,
                    icon: noteObject.icon,
                    dateAdded: noteObject.dateAdded
                )
            }
        } catch {
            print("()() Failed to fetch notes: \(error)")
            return []
        }
    }

    public func debugPrintAllNotes() {
        let notes = getAllNotes()
        print("()() Всего заметок: \(notes.count)")
        notes.forEach { note in
            print("\(note.id) | \(note.title) | \(note.type.rawValue) | \(note.dateAdded)")
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }

    func clearCoreData() {

        let context = persistentContainer.viewContext
        let entities = persistentContainer.managedObjectModel.entities

        entities.compactMap({ $0.name }).forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs

            do {
                let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
            } catch {
                print("❌ Ошибка при удалении \(entityName): \(error)")
            }
        }
    }
}

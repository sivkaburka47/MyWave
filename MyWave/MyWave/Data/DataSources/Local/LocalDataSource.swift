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

    public func saveNoteDetails(noteDetails: NoteDetails) async {
        await context.perform {
            let noteObject = NoteObject(context: self.context)
            noteObject.id = noteDetails.note.id
            noteObject.title = noteDetails.note.title
            noteObject.emotionType = noteDetails.note.type.rawValue
            noteObject.icon = noteDetails.note.icon
            noteObject.dateAdded = noteDetails.note.dateAdded
            noteObject.activities = noteDetails.activities
            noteObject.companions = noteDetails.companions
            noteObject.locations = noteDetails.locations
            self.saveContext()
        }
    }

    public func updateNoteDetails(noteDetails: NoteDetails) async {
        await context.perform {
            let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")
            fetchRequest.predicate = NSPredicate(format: "id == %@", noteDetails.note.id)
            fetchRequest.fetchLimit = 1

            do {
                if let noteObject = try self.context.fetch(fetchRequest).first {
                    noteObject.title = noteDetails.note.title
                    noteObject.emotionType = noteDetails.note.type.rawValue
                    noteObject.icon = noteDetails.note.icon
                    noteObject.dateAdded = noteDetails.note.dateAdded
                    noteObject.activities = noteDetails.activities
                    noteObject.companions = noteDetails.companions
                    noteObject.locations = noteDetails.locations
                    self.saveContext()
                } else {
                    print("Note with id \(noteDetails.note.id) not found.")
                }
            } catch {
                print("Failed to update note: \(error)")
            }
        }
    }

    public func getNoteDetails(id: String) async -> NoteDetails? {
        return await context.perform {
            let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            fetchRequest.fetchLimit = 1

            guard let noteObject = try? self.context.fetch(fetchRequest).first else {
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
    }

    public func getAllNotes() async -> [Note] {
        let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")

        do {
            let noteObjects = try await context.perform {
                try self.context.fetch(fetchRequest)
            }

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


    public func getLatestNoteDate() async -> Date? {
        await context.perform {
            let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: true)]
            fetchRequest.fetchLimit = 1

            do {
                return try self.context.fetch(fetchRequest).first?.dateAdded
            } catch {
                print("()() Failed to fetch latest note date: \(error)")
                return nil
            }
        }
    }

    public func getWeekNotes(_ monday: Date) async -> [Note] {
        await context.perform {
            let calendar = Calendar.current
            guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: monday) else {
                return []
            }

            let fetchRequest = NSFetchRequest<NoteObject>(entityName: "NoteObject")
            fetchRequest.predicate = NSPredicate(
                format: "dateAdded >= %@ AND dateAdded <= %@",
                monday as NSDate,
                endOfWeek as NSDate
            )

            do {
                let noteObjects = try self.context.fetch(fetchRequest)
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
                print("()() Failed to fetch notes for week: \(error)")
                return []
            }
        }
    }

    // MARK: - Save Context
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}

// MARK: Help methods

extension LocalDataSource {

    public func debugPrintAllNotes() async {
        let notes = await getAllNotes()
        print("()() Всего заметок: \(notes.count)")
        notes.forEach { note in
            print("\(note.id) | \(note.title) | \(note.type.rawValue) | \(note.dateAdded)")
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
                print("()() Ошибка при удалении \(entityName): \(error)")
            }
        }
    }
}

//
//  AddNoteViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

protocol AddNoteViewModelProtocol {
    func doneButtonTapped()
    var onDataChanged: (() -> Void)? { get set }
}

final class AddNoteViewModel: AddNoteViewModelProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AddNoteCoordinator?
    private let localDataSource = LocalDataSource.shared


    var sections: [Section] = []
    var selectedTags = Set<String>()
    var isAddingTag = false
    var currentEditingSection: Int?

    let emotionTitle: String
    let selectedDate: Date
    let emotionType: EmotionType
    let iconName: String
    let selectedCardType: CardType

    private let noteId: String?

    var onDataChanged: (() -> Void)?

    // MARK: - Initialization
    
    init(
        noteId: String? = nil,
        emotionTitle: String = "",
        emotionType: EmotionType = .green,
        iconName: String = "",
        date: Date = Date()
    ) {
        self.noteId = noteId

        let defaultActivities = ["Прием пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"]
        let defaultCompanions = ["Один", "Друзья", "Семья", "Коллеги", "Партнер", "Питомцы"]
        let defaultLocations = ["Дом", "Работа", "Школа", "Транспорт", "Улица"]

        if let noteId = noteId,
           let details = localDataSource.getNoteDetails(by: noteId) {

            self.emotionTitle = details.note.title
            self.emotionType = details.note.type
            self.iconName = details.note.icon
            self.selectedDate = details.note.dateAdded
            self.selectedCardType = CardType(emotionType: details.note.type)

            let combinedActivities = Array(Set(defaultActivities + details.activities))
            let combinedCompanions = Array(Set(defaultCompanions + details.companions))
            let combinedLocations = Array(Set(defaultLocations + details.locations))

            self.sections = [
                Section(title: "Чем вы занимались", items: combinedActivities),
                Section(title: "С кем вы были?", items: combinedCompanions),
                Section(title: "Где вы были?", items: combinedLocations)
            ]

            self.selectedTags = Set(details.activities + details.companions + details.locations)
        } else {
            self.emotionTitle = emotionTitle
            self.emotionType = emotionType
            self.iconName = iconName
            self.selectedDate = date
            self.selectedCardType = CardType(emotionType: emotionType)

            self.sections = [
                Section(title: "Чем вы занимались", items: defaultActivities),
                Section(title: "С кем вы были?", items: defaultCompanions),
                Section(title: "Где вы были?", items: defaultLocations)
            ]
        }
    }


}

// MARK: - Public Methods

extension AddNoteViewModel {
    
    func setEditingSection(_ section: Int?) {
        currentEditingSection = section
    }
    
    func toggleAddingTag() {
        isAddingTag.toggle()
    }
    
    func setAddingTag(_ value: Bool) {
        isAddingTag = value
    }
    
    func toggleTagSelection(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    func addTag(_ tag: String, to section: Int) {
        sections[section].items.append(tag)
        selectedTags.insert(tag)
    }

    func doneButtonTapped() {
        completeFlow()
    }
}

// MARK: - Private Methods
extension AddNoteViewModel {

    private func completeFlow() {
        saveNote()
        coordinator?.completeFlow()
    }

    private func saveNote() {
        let note = Note(
            id: noteId ?? UUID().uuidString,
            title: emotionTitle,
            type: emotionType,
            icon: iconName,
            dateAdded: selectedDate
        )

        let activities = sections[0].items.filter { selectedTags.contains($0) }
        let companions = sections[1].items.filter { selectedTags.contains($0) }
        let locations = sections[2].items.filter { selectedTags.contains($0) }

        let noteDetails = NoteDetails(
            note: note,
            activities: activities,
            companions: companions,
            locations: locations
        )

        localDataSource.saveNoteDetails(noteDetails)
    }
}

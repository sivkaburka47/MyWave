//
//  AddNoteViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

protocol AddNoteViewModelProtocol {
    func doneButtonTapped()
}

final class AddNoteViewModel: AddNoteViewModelProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AddNoteCoordinator?
    private let localDataSource = LocalDataSource.shared

    var sections: [Section] = [
        Section(title: "Чем вы занимались", items: ["Прием пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"]),
        Section(title: "С кем вы были?", items: ["Один", "Друзья", "Семья", "Коллеги", "Партнер", "Питомцы"]),
        Section(title: "Где вы были?", items: ["Дом", "Работа", "Школа", "Транспорт", "Улица"])
    ]
    
    var selectedTags = Set<String>()
    var isAddingTag = false
    var currentEditingSection: Int?

    let emotionTitle: String
    let selectedDate: Date
    let emotionType: EmotionType
    let iconName: String


    let selectedCardType: CardType

    // MARK: - Initialization
    
    init(
        selectedDate: Date = Date(),
        emotionTitle: String,
        emotionType: EmotionType,
        iconName: String
    ) {
        self.selectedDate = selectedDate
        self.emotionTitle = emotionTitle
        self.selectedCardType = CardType(emotionType: emotionType)
        self.iconName = iconName
        self.emotionType = emotionType
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
            id: UUID().uuidString,
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

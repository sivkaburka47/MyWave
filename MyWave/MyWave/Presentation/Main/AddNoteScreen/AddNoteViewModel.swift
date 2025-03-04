//
//  AddNoteViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

protocol AddNoteViewModelProtocol {
    func completeFlow()
}

final class AddNoteViewModel: AddNoteViewModelProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AddNoteCoordinator?
    
    var sections: [Section] = [
        Section(title: "Чем вы занимались", items: ["Прием пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"]),
        Section(title: "С кем вы были?", items: ["Один", "Друзья", "Семья", "Коллеги", "Партнер", "Питомцы"]),
        Section(title: "Где вы были?", items: ["Дом", "Работа", "Школа", "Транспорт", "Улица"])
    ]
    
    var selectedTags = Set<String>()
    var isAddingTag = false
    var currentEditingSection: Int?
    
    let selectedDate: Date
    let selectedEmotion: String
    let selectedCardType: CardType
    
    // MARK: - Initialization
    
    init(
        selectedDate: Date = Date(),
        selectedEmotion: String = "усталость",
        selectedCardType: CardType = .blue
    ) {
        self.selectedDate = selectedDate
        self.selectedEmotion = selectedEmotion
        self.selectedCardType = selectedCardType
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
    
    func completeFlow() {
        coordinator?.completeFlow()
    }
}

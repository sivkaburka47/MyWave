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
    weak var coordinator: AddNoteCoordinator?
    
    var selectedDate: Date
    var selectedEmotion: String
    var selectedCardType: CardType

    var activities: [String]
    var companions: [String]
    var places: [String]
    
    
    
    init(
        selectedDate: Date = Date(),
        selectedEmotion: String = "усталость",
        selectedCardType: CardType = .blue,
        activities: [String] = ["Приём пищи", "Тренировка", "Отдых"],
        companions: [String] = ["Один", "Друзья", "Семья"],
        places: [String] = ["Дом", "Работа", "Улица"]
    ) {
        self.selectedDate = selectedDate
        self.selectedEmotion = selectedEmotion
        self.selectedCardType = selectedCardType
        self.activities = activities
        self.companions = companions
        self.places = places
    }
    
    func completeFlow() {
        coordinator?.completeFlow()
    }
}

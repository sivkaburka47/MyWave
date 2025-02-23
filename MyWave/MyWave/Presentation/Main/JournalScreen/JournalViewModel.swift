//
//  MainViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 21.02.2025.
//

import Foundation

protocol JournalViewModelProtocol {
    func startAddNoteFlow()
    func editNote()
}

final class JournalViewModel: JournalViewModelProtocol {
    weak var coordinator: JournalCoordinator?
    
    func startAddNoteFlow() {
        coordinator?.navigateToEmotionSelection()
    }
    
    func editNote(){
        coordinator?.navigateToAddNote()
    }
}

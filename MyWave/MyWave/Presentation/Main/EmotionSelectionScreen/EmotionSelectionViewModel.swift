//
//  EmotionSelectionViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

protocol EmotionSelectionViewModelProtocol {
    func navigateToAddNote()
}

final class EmotionSelectionViewModel: EmotionSelectionViewModelProtocol {
    weak var coordinator: EmotionSelectionCoordinator?
    
    func navigateToAddNote() {
        coordinator?.navigateToAddNote()
    }
}

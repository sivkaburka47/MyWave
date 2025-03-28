//
//  EmotionSelectionViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation
import UIKit

protocol EmotionSelectionViewModelProtocol {
    func navigateToAddNote()
}

final class EmotionSelectionViewModel: EmotionSelectionViewModelProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: EmotionSelectionCoordinator?
    
    let emotions: [(String, UIColor)] = [
            ("Ярость", UIColor(named: "cusRed")!), ("Напряжение", UIColor(named: "cusRed")!),
            ("Зависть", UIColor(named: "cusRed")!), ("Беспокойство", UIColor(named: "cusRed")!),
            ("Возбуждение", UIColor(named: "cusYellow")!), ("Восторг", UIColor(named: "cusYellow")!),
            ("Уверенность", UIColor(named: "cusYellow")!), ("Счастье", UIColor(named: "cusYellow")!),
            ("Выгорание", UIColor(named: "cusBlue")!), ("Усталость", UIColor(named: "cusBlue")!),
            ("Депрессия", UIColor(named: "cusBlue")!), ("Апатия", UIColor(named: "cusBlue")!),
            ("Спокойствие", UIColor(named: "cusGreen")!), ("Удовлетворённость", UIColor(named: "cusGreen")!),
            ("Благодарность", UIColor(named: "cusGreen")!), ("Защищённость", UIColor(named: "cusGreen")!)
        ]
}

// MARK: - Public Methods

extension EmotionSelectionViewModel {
    
    func navigateToAddNote() {
        coordinator?.navigateToAddNote()
    }
}

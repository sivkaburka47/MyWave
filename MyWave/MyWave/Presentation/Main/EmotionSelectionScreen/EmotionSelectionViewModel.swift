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

    var selectedEmotionType: EmotionType?
    var selectedEmotionIcon: String?
    var selectedEmotionTitle: String?

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
        guard let emotionType = selectedEmotionType,
              let icon = selectedEmotionIcon,
              let title = selectedEmotionTitle else {
            print("Emotion data is not selected")
            return
        }

        coordinator?.navigateToAddNote(emotionType: emotionType, iconName: icon, emotionTitle: title)
    }


    func updateSelection(emotionTitle: String, color: UIColor) {
        self.selectedEmotionType = emotionType(for: color)
        self.selectedEmotionIcon = emotionIcon(for: color)
        self.selectedEmotionTitle = emotionTitle
    }
}

// MARK: - Helpers
extension EmotionSelectionViewModel {
    private func emotionType(for color: UIColor) -> EmotionType {
        if color == UIColor(named: "cusRed") {
            return .red
        } else if color == UIColor(named: "cusYellow") {
            return .yellow
        } else if color == UIColor(named: "cusBlue") {
            return .blue
        } else if color == UIColor(named: "cusGreen") {
            return .green
        } else {
            fatalError("Unexpected color: \(color)")
        }
    }

    private func emotionIcon(for color: UIColor) -> String {
        if color == UIColor(named: "cusRed") {
            return "redCardImage"
        } else if color == UIColor(named: "cusYellow") {
            return "yellowCardImage"
        } else if color == UIColor(named: "cusBlue") {
            return "blueCardImage"
        } else if color == UIColor(named: "cusGreen") {
            return "greenCardImage"
        } else {
            fatalError("Unexpected color: \(color)")
        }
    }
}

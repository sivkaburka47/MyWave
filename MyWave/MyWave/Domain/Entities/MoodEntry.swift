//
//  MoodEntry.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 03.03.2025.
//

import Foundation

struct MoodEntry {
    let partOfDay: PartOfDay
    let emotions: [(type: EmotionType, count: Int)]
}

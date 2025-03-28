//
//  EmotionFrequency.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 02.03.2025.
//

import Foundation

struct EmotionFrequency {
    let title: String
    let emotion: EmotionType
    let icon: String
    let count: Int
}

struct EmotionKey: Hashable {
    let title: String
    let emotion: EmotionType
}

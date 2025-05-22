//
//  StatisticsViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

final class StatisticsViewModel {
    
    // MARK: - Properties
    
    weak var coordinator: StatisticsCoordinator?
    private let localDataSource = LocalDataSource.shared
    
    var weeks: [String] = []
    var weekMondays: [Date] = []
    var notes: [Note] = []

    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex < 0 { selectedIndex = 0 }
            if selectedIndex >= weeks.count { selectedIndex = weeks.count - 1 }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        if let startDate = localDataSource.getLatestNoteDate() {
            setupWeeks(from: startDate, to: Date())
        }
    }
    
    // MARK: - Data Setup
    
    func setupWeeks(from startDate: Date, to endDate: Date) {
        weeks = generateWeeks(from: startDate, to: endDate)
        selectedIndex = weeks.count - 1
    }
}

// MARK: - Public Methods

extension StatisticsViewModel {

    func generateWeeks(from startDate: Date, to endDate: Date) -> [String] {
        weekMondays = []
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")

        var weeks: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.locale = calendar.locale

        var currentWeekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate))!

        while currentWeekStart <= endDate {
            weekMondays.append(currentWeekStart)
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: currentWeekStart)!

            let startMonth = calendar.component(.month, from: currentWeekStart)
            let endMonth = calendar.component(.month, from: endOfWeek)

            let startFormat = startMonth != endMonth ? "d MMM" : "d"
            dateFormatter.dateFormat = startFormat
            let startStr = dateFormatter.string(from: currentWeekStart)

            dateFormatter.dateFormat = "d MMM"
            let endStr = dateFormatter.string(from: endOfWeek)

            let startComponents = startStr.split(separator: " ")
            let endComponents = endStr.split(separator: " ")

            let formattedStart = startComponents.count == 1 ? "\(startComponents[0])" : "\(startComponents[0]) \(startComponents[1].prefix(3))"
            let formattedEnd = "\(endComponents[0]) \(endComponents[1].prefix(3))"

            let weekRangeString = "\(formattedStart) - \(formattedEnd)"
            weeks.append(weekRangeString)

            currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
        }

        return weeks
    }


    func getAvailableWeeks() -> [String] {
        weeks
    }

    func calculateColoredCircles(from notes: [Note]) -> [ColoredCircle] {
        let countDict = notes.reduce(into: [EmotionType: Int]()) { counts, note in
            counts[note.type, default: 0] += 1
        }

        let total = Float(notes.count)
        guard total > 0 else { return [] }

        return countDict.map { (type, count) in
            ColoredCircle(type: type, percent: Float(count) / total * 100)
        }
    }

    func getNotes(for weekIndex: Int) -> [Note] {
        guard weekIndex < weekMondays.count else { return [] }
        let monday = weekMondays[weekIndex]
        return localDataSource.getWeekNotes(monday)
    }


    func getTopEmotions(for notes: [Note]) -> [EmotionFrequency] {
        var frequencyDict: [EmotionKey: (count: Int, icon: String)] = [:]
        
        for note in notes {
            let key = EmotionKey(title: note.title, emotion: note.type)
            if let existing = frequencyDict[key] {
                frequencyDict[key] = (existing.count + 1, existing.icon)
            } else {
                frequencyDict[key] = (1, note.icon)
            }
        }
        
        let frequencies = frequencyDict.map { key, value in
            EmotionFrequency(title: key.title, emotion: key.emotion, icon: value.icon, count: value.count)
        }
        
        return Array(frequencies.sorted { $0.count > $1.count }.prefix(7))
    }
    
    func getMoodEntries(for notes: [Note]) -> [MoodEntry] {
        var moodCounts: [PartOfDay: [EmotionType: Int]] = [
            .earlyMorning: [:], .morning: [:], .day: [:], .evening: [:], .lateEvening: [:]
        ]
        
        for part in moodCounts.keys {
            moodCounts[part] = [.red: 0, .blue: 0, .yellow: 0, .green: 0]
        }
        
        for note in notes {
            let part = PartOfDay.from(date: note.dateAdded)
            moodCounts[part]?[note.type]! += 1
        }
        
        let orderedParts: [PartOfDay] = [.earlyMorning, .morning, .day, .evening, .lateEvening]
        
        return orderedParts.map { part in
            guard let counts = moodCounts[part] else {
                return MoodEntry(partOfDay: part, emotions: [])
            }
            let emotions = counts
                .filter { $0.value > 0 }
                .sorted { $0.key.rawValue < $1.key.rawValue }
                .map { (type: $0.key, count: $0.value) }
            return MoodEntry(partOfDay: part, emotions: emotions)
        }
    }
}

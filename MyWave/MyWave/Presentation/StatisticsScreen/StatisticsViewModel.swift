//
//  StatisticsViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation

final class StatisticsViewModel {
    weak var coordinator: StatisticsCoordinator?
    
    private var weeksData: [WeekStatistics] = []
    
    init() {
        generateFixedData()
    }
    
    private func generateFixedData() {
        let fullNotes = [
            Note(title: "Возбуждение", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-06 6:10")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-05 10:20")!),
            Note(title: "Любовь", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-06 13:10")!),
            Note(title: "Возбуждение", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-06 13:10")!),
            Note(title: "Возбуждение", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-06 13:10")!),
            Note(title: "Возбуждение", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-06 13:10")!),
            Note(title: "Вдохновение", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-07 15:00")!),
            Note(title: "Вдохновение", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-07 15:00")!),
            Note(title: "Возбуждение", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-06 18:10")!),
            Note(title: "Усталость", type: .yellow, icon: "yellowCardImage", dateAdded: dateFromString("2025-03-08 18:30")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-09 10:00")!),
            
            Note(title: "Любовь", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-10 11:30")!),
            Note(title: "Вдохновение", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-11 14:45")!),
            Note(title: "Усталость", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-12 09:15")!),
            Note(title: "Депрессия", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-13 16:20")!),
            Note(title: "Благодарность", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-16 08:30")!),
            Note(title: "Грусть", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-16 14:20")!),
            Note(title: "Энергия", type: .yellow, icon: "yellowCardImage", dateAdded: dateFromString("2025-03-16 10:00")!),
            Note(title: "Выгорание", type: .blue, icon: "blueCardImageSec", dateAdded: dateFromString("2025-03-16 18:20")!),
            Note(title: "Возбуждение", type: .yellow, icon: "yellowCardImageSec", dateAdded: dateFromString("2025-03-16 19:00")!),
            Note(title: "Апатия", type: .blue, icon: "blueCardImageSec", dateAdded: dateFromString("2025-03-16 18:20")!),
            Note(title: "Счастье", type: .yellow, icon: "yellowCardImageSec", dateAdded: dateFromString("2025-03-16 19:00")!),
            
            Note(title: "Спокойствие", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-17 17:45")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-18 11:15")!),
            Note(title: "Любовь", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-19 09:45")!),
            Note(title: "Вдохновение", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-20 16:30")!),
            
            Note(title: "Усталость", type: .yellow, icon: "yellowCardImageSec", dateAdded: dateFromString("2025-03-21 18:15")!),
            Note(title: "Радость", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-22 08:00")!),
            Note(title: "Грусть", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-23 12:45")!),
            Note(title: "Энергия", type: .yellow, icon: "yellowCardImage", dateAdded: dateFromString("2025-03-24 15:30")!),
            
            Note(title: "Спокойствие", type: .green, icon: "greenCardImage", dateAdded: dateFromString("2025-03-25 19:10")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-26 10:20")!),
            Note(title: "Любовь", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-03-27 14:15")!),
            Note(title: "Радость", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-03-28 08:00")!),
            
            Note(title: "Спокойствие", type: .green, icon: "redCardImage", dateAdded: dateFromString("2025-03-31 19:10")!),
            Note(title: "Гнев", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-04-01 10:20")!),
            Note(title: "Любовь", type: .red, icon: "redCardImage", dateAdded: dateFromString("2025-04-01 14:15")!),
            Note(title: "Радость", type: .blue, icon: "blueCardImage", dateAdded: dateFromString("2025-04-04 08:00")!),
        ]

        weeksData = sortNotesByWeeks(notes: fullNotes)

    }

    private func dateFromString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }
    
    func fetchWeeksData() -> [WeekStatistics] {
        return weeksData
    }
    
    func getAvailableWeeks() -> [String] {
        return weeksData.map { $0.weekRange }
    }
    
    func getStatistics(for week: String) -> WeekStatistics {
        return weeksData.first { $0.weekRange == week } ?? WeekStatistics(
            weekRange: week,
            notesByDate: []
        )
    }

    func sortNotesByWeeks(notes: [Note]) -> [WeekStatistics] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")
        
        var groupedNotes = [Date: [Note]]()
        
        for note in notes {
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: note.dateAdded)
            guard let startOfWeek = calendar.date(from: components) else { continue }
            
            groupedNotes[startOfWeek, default: []].append(note)
        }
        
        let sortedWeekStarts = groupedNotes.keys.sorted()
        
        for weekStart in sortedWeekStarts {
            guard var notes = groupedNotes[weekStart] else { continue }
            notes.sort { note1, note2 in
                let order1 = calendar.component(.weekday, from: note1.dateAdded)
                let order2 = calendar.component(.weekday, from: note2.dateAdded)
                let adjustedOrder1 = (order1 - calendar.firstWeekday + 7) % 7
                let adjustedOrder2 = (order2 - calendar.firstWeekday + 7) % 7
                return adjustedOrder1 < adjustedOrder2
            }
            groupedNotes[weekStart] = notes
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let weeks = sortedWeekStarts.compactMap { weekStart -> WeekStatistics? in
            guard
                let endOfWeek = calendar.date(byAdding: .day, value: 6, to: weekStart),
                let notes = groupedNotes[weekStart],
                !notes.isEmpty
            else { return nil }
            
            let startMonth = calendar.component(.month, from: weekStart)
            let endMonth = calendar.component(.month, from: endOfWeek)
            
            let startFormat = startMonth != endMonth ? "d MMM" : "d"
            dateFormatter.dateFormat = startFormat
            let startStr = dateFormatter.string(from: weekStart)
            
            dateFormatter.dateFormat = "d MMM"
            let endStr = dateFormatter.string(from: endOfWeek)
            
            let startComponents = startStr.split(separator: " ")
            let endComponents = endStr.split(separator: " ")
            
            let formattedStart: String
            let formattedEnd: String
              
            if startComponents.count == 1 {
                formattedStart = "\(startComponents[0])"
            } else {
                formattedStart = "\(startComponents[0]) \(startComponents[1].prefix(3))"
            }

            formattedEnd = "\(endComponents[0]) \(endComponents[1].prefix(3))"
              
            let weekRangeString = "\(formattedStart) - \(formattedEnd)"
            
            
            return WeekStatistics(weekRange: weekRangeString, notesByDate: notes)
        }
        
        return weeks
    }
    
    func getTopEmotions(for week: WeekStatistics) -> [EmotionFrequency] {
        var frequencyDict: [EmotionKey: (count: Int, icon: String)] = [:]
        
        for note in week.notesByDate {
            let key = EmotionKey(title: note.title, emotion: note.type)
            
            if let existing = frequencyDict[key] {
                frequencyDict[key] = (existing.count + 1, existing.icon)
            } else {
                frequencyDict[key] = (1, note.icon)
            }
        }
        
        let frequencies = frequencyDict.map { key, value in
            EmotionFrequency(
                title: key.title,
                emotion: key.emotion,
                icon: value.icon,
                count: value.count
            )
        }
        
        let sortedByCount = frequencies.sorted { $0.count > $1.count }
        
        let top7 = Array(sortedByCount.prefix(7))
        
        let emotionOrder: [EmotionType] = [.red, .blue, .yellow, .green]
        
        return top7.sorted {
            let index1 = emotionOrder.firstIndex(of: $0.emotion) ?? Int.max
            let index2 = emotionOrder.firstIndex(of: $1.emotion) ?? Int.max
            return index1 == index2 ? $0.count > $1.count : index1 < index2
        }
    }
    
    func getMoodEntries(for week: WeekStatistics) -> [MoodEntry] {
        var moodCounts: [PartOfDay: [EmotionType: Int]] = [
            .earlyMorning: [:],
            .morning: [:],
            .day: [:],
            .evening: [:],
            .lateEvening: [:]
        ]
        
        for part in moodCounts.keys {
            moodCounts[part] = [
                .red: 0,
                .blue: 0,
                .yellow: 0,
                .green: 0
            ]
        }
        
        for note in week.notesByDate {
            let part = determinePartOfDay(for: note.dateAdded)
            moodCounts[part]?[note.type]! += 1
        }
        
        let orderedParts: [PartOfDay] = [
            .earlyMorning,
            .morning,
            .day,
            .evening,
            .lateEvening
        ]
        
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
    

    private func determinePartOfDay(for date: Date) -> PartOfDay {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<8: return .earlyMorning
        case 8..<12: return .morning
        case 12..<17: return .day
        case 17..<21: return .evening
        default: return .lateEvening
        }
    }
}

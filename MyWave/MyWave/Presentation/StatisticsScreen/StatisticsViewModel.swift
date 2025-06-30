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
    private let getColoredCirclesUseCase: GetColoredCirclesUseCase
    private let getWeekNotesUseCase: GetWeekNotesUseCase
    private let getFrequentEmotionsUseCase: GetFrequentEmotionsUseCase
    private let getMoodInDayUseCase: GetMoodInDayUseCase
    private let getLatestNoteDateUseCase: GetLatestNoteDateUseCase

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
        self.getColoredCirclesUseCase = GetColoredCirclesUseCaseImpl.create()
        self.getWeekNotesUseCase = GetWeekNotesUseCaseImpl.create()
        self.getFrequentEmotionsUseCase = GetFrequentEmotionsUseCaseImpl.create()
        self.getMoodInDayUseCase = GetMoodInDayUseCaseImpl.create()
        self.getLatestNoteDateUseCase = GetLatestNoteDateUseCaseImpl.create()

        Task {
            await initializeData()
        }
    }
    
    func setupWeeks(from startDate: Date, to endDate: Date) {
        weeks = generateWeeks(from: startDate, to: endDate)
        selectedIndex = weeks.count - 1
    }
}

// MARK: - Public Methods

extension StatisticsViewModel {

    func generateWeeks(from startDate: Date, to endDate: Date) -> [String] {
        self.weekMondays = []
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

    func calculateColoredCircles(for weekIndex: Int) async -> [ColoredCircle] {
        guard weekIndex < weekMondays.count else { return [] }
        let monday = weekMondays[weekIndex]
        return await getColoredCirclesUseCase.execute(monday: monday)
    }

    func getNotes(for weekIndex: Int) async -> [Note] {
        guard weekIndex < weekMondays.count else { return [] }
        let monday = weekMondays[weekIndex]
        return await getWeekNotesUseCase.execute(monday: monday)
    }

    func getTopEmotions(for weekIndex: Int) async -> [EmotionFrequency] {
        guard weekIndex < weekMondays.count else { return [] }
        let monday = weekMondays[weekIndex]
        return await getFrequentEmotionsUseCase.execute(monday: monday)
    }

    func getMoodEntries(for weekIndex: Int) async -> [MoodEntry] {
        guard weekIndex < weekMondays.count else { return [] }
        let monday = weekMondays[weekIndex]
        return await getMoodInDayUseCase.execute(monday: monday)
    }
}

// MARK: - Private Methods

private extension StatisticsViewModel {

    func getLatestNoteDate() async -> Date? {
        return await getLatestNoteDateUseCase.execute()
    }

    func initializeData() async {
        let endDate = Date()
        let startDate = await getLatestNoteDate() ?? endDate
        setupWeeks(from: startDate, to: endDate)
    }
}

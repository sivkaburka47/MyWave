//
//  JournalViewModelTests.swift
//  MyWaveTests
//
//  Created by Станислав Дейнекин on 24.05.2025.
//

import XCTest
@testable import MyWave

final class JournalViewModelTests: XCTestCase {

    var sut: JournalViewModel!

    override func setUp() {
        super.setUp()
        sut = JournalViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Series Duration Tests

    /**
     Тест проверяет подсчет серии последовательных дней с записями.
     При наличии записей за сегодня, вчера и позавчера,
     серия должна составить 3 дня.
     Ожидаемый результат -- 3 дня непрерывной серии.
     */
    func testCalculateSeriesDuration_WithConsecutiveDays() {
        // Given
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!

        sut.allNotes = [
            Note(id: "1", title: "Today", type: .green, icon: "icon", dateAdded: today),
            Note(id: "2", title: "Yesterday", type: .blue, icon: "icon", dateAdded: yesterday),
            Note(id: "3", title: "Two days ago", type: .yellow, icon: "icon", dateAdded: twoDaysAgo)
        ]

        // When
        let duration = sut.calculateSeriesDuration()

        // Then
        XCTAssertEqual(duration, 3, "Серия должна составлять 3 дня при наличии записей за три последовательных дня")
    }

    /**
     Тест проверяет случай, когда нет ни одной записи.
     Ожидаемый результат -- серия длиной 0 дней.
     */
    func testCalculateSeriesDuration_WithNoNotes() {
        // Given
        sut.allNotes = []

        // When
        let duration = sut.calculateSeriesDuration()

        // Then
        XCTAssertEqual(duration, 0, "При отсутствии записей серия должна быть 0 дней")
    }

    /**
     Тест проверяет случай, когда записи есть, но не сегодня.
     Ожидаемый результат -- серия длиной 0 дней.
     */
    func testCalculateSeriesDuration_WithNotesButNotToday() {
        // Given
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!

        sut.allNotes = [
            Note(id: "1", title: "Yesterday", type: .green, icon: "icon", dateAdded: yesterday),
            Note(id: "2", title: "Two days ago", type: .blue, icon: "icon", dateAdded: twoDaysAgo)
        ]

        // When
        let duration = sut.calculateSeriesDuration()

        // Then
        XCTAssertEqual(duration, 0, "Если нет записей за сегодня, серия должна быть 0 дней")
    }

    /**
     Тест проверяет случай с записями за сегодня и вчера, но без позавчера.
     Ожидаемый результат -- серия длиной 2 дня.
     */
    func testCalculateSeriesDuration_WithTodayAndYesterdayOnly() {
        // Given
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        sut.allNotes = [
            Note(id: "1", title: "Today", type: .green, icon: "icon", dateAdded: today),
            Note(id: "2", title: "Yesterday", type: .blue, icon: "icon", dateAdded: yesterday)
        ]

        // When
        let duration = sut.calculateSeriesDuration()

        // Then
        XCTAssertEqual(duration, 2, "Серия должна составлять 2 дня при записях за сегодня и вчера")
    }

    /**
     Тест проверяет подсчет серии дней при наличии пропуска.
     При наличии записей только за сегодня и три дня назад,
     серия должна прерваться и составить только 1 день.
     Ожидаемый результат -- 1 день серии.
     */
    func testCalculateSeriesDuration_WithGap() {
        // Given
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!

        sut.allNotes = [
            Note(id: "1", title: "Today", type: .green, icon: "icon", dateAdded: today),
            Note(id: "2", title: "Three days ago", type: .blue, icon: "icon", dateAdded: threeDaysAgo)
        ]

        // When
        let duration = sut.calculateSeriesDuration()

        // Then
        XCTAssertEqual(duration, 1, "Серия должна составлять 1 день из-за пропуска в записях")
    }

    // MARK: - Today Entries Tests

    /**
     Тест проверяет корректность получения записей за текущий день.
     При наличии двух записей за сегодня и одной за вчера,
     должны вернуться только сегодняшние записи.
     Ожидаемый результат -- 2 записи с корректными типами эмоций.
     */
    func testGetTodayEntries() {
        // Given
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        sut.allNotes = [
            Note(id: "1", title: "Today 1", type: .green, icon: "icon", dateAdded: today),
            Note(id: "2", title: "Today 2", type: .blue, icon: "icon", dateAdded: today),
            Note(id: "3", title: "Yesterday", type: .yellow, icon: "icon", dateAdded: yesterday)
        ]

        // When
        let todayEntries = sut.getTodayEntries()

        // Then
        XCTAssertEqual(todayEntries.count, 2, "Количество записей за сегодня должно быть равно 2")
        XCTAssertEqual(todayEntries, [.green, .blue], "CardType значений должно быть два: green и blue")
    }
    /**
     Тест проверяет случай, когда нет записей за сегодня.
     Ожидаемый результат -- пустой массив.
     */
    func testGetTodayEntries_WithNoTodayNotes() {
        // Given
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!

        sut.allNotes = [
            Note(id: "1", title: "Yesterday", type: .yellow, icon: "icon", dateAdded: yesterday)
        ]

        // When
        let todayEntries = sut.getTodayEntries()

        // Then
        XCTAssertTrue(todayEntries.isEmpty, "При отсутствии записей за сегодня должен возвращаться пустой массив")
    }
    /**
     Тест проверяет случай с несколькими записями одного типа за сегодня.
     Ожидаемый результат -- массив с повторяющимися типами.
     */
    func testGetTodayEntries_WithMultipleSameTypeNotes() {
        // Given
        let today = Date()

        sut.allNotes = [
            Note(id: "1", title: "Today 1", type: .green, icon: "icon", dateAdded: today),
            Note(id: "2", title: "Today 2", type: .green, icon: "icon", dateAdded: today),
            Note(id: "3", title: "Today 3", type: .green, icon: "icon", dateAdded: today)
        ]

        // When
        let todayEntries = sut.getTodayEntries()

        // Then
        XCTAssertEqual(todayEntries, [.green, .green, .green], "Должны возвращаться все записи за сегодня, даже с одинаковым типом")
    }

    // MARK: - Formatting Tests

    /**
     Тест проверяет корректность форматирования количества записей
     с учетом правил склонения в русском языке.
     Проверяются различные числовые значения: 1, 2, 5, 11, 21.
     Ожидаемый результат -- корректное склонение слова "запись"
     для каждого числового значения.
     */
    func testEntriesCountFormatting() {

        // 1 запись
        sut.entriesCount = 1
        XCTAssertEqual(sut.entriesCountString(), "1 запись", "Для числа 1 должно быть склонение 'запись'")

        // 2 записи
        sut.entriesCount = 2
        XCTAssertEqual(sut.entriesCountString(), "2 записи", "Для числа 2 должно быть склонение 'записи'")

        // 5 записей
        sut.entriesCount = 5
        XCTAssertEqual(sut.entriesCountString(), "5 записей", "Для числа 5 должно быть склонение 'записей'")

        // 11 записей
        sut.entriesCount = 11
        XCTAssertEqual(sut.entriesCountString(), "11 записей", "Для числа 11 должно быть склонение 'записей'")

        // 21 запись
        sut.entriesCount = 21
        XCTAssertEqual(sut.entriesCountString(), "21 запись", "Для числа 21 должно быть склонение 'запись'")
    }

}


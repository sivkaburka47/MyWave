//
//  OptionsViewModel.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 22.02.2025.
//

import Foundation
import LocalAuthentication

final class OptionsViewModel {
    // MARK: - Properties
    weak var coordinator: OptionsCoordinator?
    private var reminders: [String] = []
    private var isReminderEnabled: Bool = false
    private var isFaceIdEnabled: Bool = false

    var onRemindersUpdated: (([String]) -> Void)?
    var onError: ((Error) -> Void)?
    var onReminderSwitchChanged: ((Bool) -> Void)?
    var onFaceIdSwitchChanged: ((Bool) -> Void)?

    // MARK: - Lifecycle
    func onDidLoad() {
        loadSettings()
    }

    // MARK: - Public Methods
    func addReminder(time: String) {
        reminders.append(time)
        saveReminders()
        NotificationService.shared.scheduleDailyReminders(times: reminders)
        onRemindersUpdated?(reminders)
    }

    func removeReminder(at index: Int) {
        guard index >= 0 && index < reminders.count else { return }
        reminders.remove(at: index)
        saveReminders()
        NotificationService.shared.scheduleDailyReminders(times: reminders)
        onRemindersUpdated?(reminders)
    }


    func toggleReminderSwitch(isOn: Bool) {
        isReminderEnabled = isOn
        saveReminderSetting()
        if isOn {
            NotificationService.shared.scheduleDailyReminders(times: reminders)
        } else {
            NotificationService.shared.cancelAllNotifications()
        }
        onReminderSwitchChanged?(isOn)
    }


    func toggleFaceIdSwitch(isOn: Bool) {
        guard canUseFaceID() else {
            onError?(LAError(.biometryNotAvailable))
            return
        }
        isFaceIdEnabled = isOn
        saveFaceIdSetting()
        onFaceIdSwitchChanged?(isOn)
    }

    func getReminders() -> [String] {
        return reminders
    }

    func getReminderSwitchState() -> Bool {
        return isReminderEnabled
    }

    func getFaceIdSwitchState() -> Bool {
        return isFaceIdEnabled
    }

    // MARK: - Private Methods

    private func loadSettings() {
        if let savedReminders = UserDefaults.standard.array(forKey: "reminders") as? [String] {
            reminders = savedReminders
            onRemindersUpdated?(reminders)
        }
        isReminderEnabled = UserDefaults.standard.bool(forKey: "isReminderEnabled")
        isFaceIdEnabled = UserDefaults.standard.bool(forKey: "isFaceIdEnabled")
        onReminderSwitchChanged?(isReminderEnabled)
        onFaceIdSwitchChanged?(isFaceIdEnabled)
    }

    private func saveReminders() {
        UserDefaults.standard.set(reminders, forKey: "reminders")
    }

    private func saveReminderSetting() {
        UserDefaults.standard.set(isReminderEnabled, forKey: "isReminderEnabled")
    }

    private func saveFaceIdSetting() {
        UserDefaults.standard.set(isFaceIdEnabled, forKey: "isFaceIdEnabled")
    }

    private func canUseFaceID() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}

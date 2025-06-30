//
//  NotificationService.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 23.05.2025.
//

import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private init() {}

    func requestAuthorization(completion: ((Bool) -> Void)? = nil) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Ошибка запроса уведомлений: \(error.localizedDescription)")
            }
            completion?(granted)
        }
    }

    func scheduleDailyReminders(times: [String]) {
        center.removeAllPendingNotificationRequests()

        for timeString in times {
            let parts = timeString.split(separator: ":")
            guard parts.count == 2,
                  let hour = Int(parts[0]),
                  let minute = Int(parts[1]) else { continue }

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute

            let content = UNMutableNotificationContent()
            content.title = "MyWave"
            content.body = "Пришло время добавить запись о вашем настроении!"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let identifier = "reminder_\(hour)_\(minute)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("Ошибка добавления уведомления: \(error.localizedDescription)")
                }
            }
        }
    }

    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}


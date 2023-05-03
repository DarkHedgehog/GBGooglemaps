//
//  NotificationService.swift
//  GBGooglemaps
//
//  Created by Aleksandr Derevenskih on 03.05.2023.
//

import Foundation
import UserNotifications

final class NotificationService {
    static var shared = NotificationService()

    var isNotificationsAllowed = false

    private init () {
    }

    func configure() {
        readPermissions()
    }

    func sendNotification() {
        guard isNotificationsAllowed else {
            return
        }
        let content = makeNotificationContent()
        let trigger = makeIntervalNotificatioTrigger()
        let request = UNNotificationRequest(
            identifier: "alaram",
            content: content,
            trigger: trigger
        )
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent() // Заголовок
        content.title = "Вернись"
        content.subtitle = "UNNotificationContent"
        content.body = "Я скучаю"
        content.badge = 0
        return content
    }

    func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(
            timeInterval: 5,
            repeats: false
        )
    }

    private func readPermissions() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .denied:
                self.isNotificationsAllowed = false
            case .notDetermined:
                self.registerPermissions()
            default:
                self.isNotificationsAllowed = true
            }
        }
    }

    private func registerPermissions() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            self.readPermissions()
        }
    }
}

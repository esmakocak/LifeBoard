//
//  NotificationManager.swift
//  LifeBoard
//
//  Created by Esma Koçak on 12.02.2025.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isNotificationAllowed: Bool = false

    private init() {
        checkNotificationStatus()
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.isNotificationAllowed = granted
            }
        }
    }

    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationAllowed = settings.authorizationStatus == .authorized
            }
        }
    }

    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func scheduleNotification(id: String, note: String, date: Date) {
        guard isNotificationAllowed else { return }

        let content = UNMutableNotificationContent()
        content.title = "LifeBoard 📌"
        content.body = note
        content.sound = UNNotificationSound.default

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("error scheduling notification: \(error.localizedDescription)")
            } else {
                print("notification successfully scheduled, Date: \(date)")
            }
        }
    }

    func removeNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification deleted: \(identifier)")
    }
}

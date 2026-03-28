// Copyright © 2026 BentzTech LLC. All rights reserved.

import Foundation
import UserNotifications
import UIKit

@MainActor
final class NotificationService: ObservableObject {

    static let shared = NotificationService()

    @Published private(set) var pendingNotificationCount = 0

    private let center = UNUserNotificationCenter.current()

    private init() {
        refreshPendingCount()
    }

    // MARK: - Permissions

    /// Requests notification authorisation; returns `true` if granted.
    func requestPermission() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted { registerForPushNotifications() }
            return granted
        } catch {
            return false
        }
    }

    func registerForPushNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }

    // MARK: - Local Notifications

    func scheduleLocalNotification(title: String, body: String, identifier: String) {
        let content       = UNMutableNotificationContent()
        content.title     = title
        content.body      = body
        content.sound     = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        center.add(request) { [weak self] _ in
            Task { await self?.refreshPendingCount() }
        }
    }

    // MARK: - Domain notifications

    /// Schedules a local alert for an upcoming dam release.
    func handleDamReleaseNotification(data: [String: Any]) {
        let riverName   = data["riverName"]   as? String ?? "Unknown River"
        let releaseTime = data["releaseTime"] as? String ?? "Unknown Time"
        scheduleLocalNotification(
            title:      "Dam Release Alert",
            body:       "\(riverName) – Scheduled release at \(releaseTime)",
            identifier: "dam-release-\(riverName)-\(releaseTime)"
                            .replacingOccurrences(of: " ", with: "-")
        )
    }

    // MARK: - Badge / count helpers

    func refreshPendingCount() {
        center.getPendingNotificationRequests { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingNotificationCount = requests.count
            }
        }
    }

    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
        pendingNotificationCount = 0
    }
}

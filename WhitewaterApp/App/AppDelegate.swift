// Copyright © 2026 BentzTech LLC. All rights reserved.

import UIKit
import UserNotifications
import OSLog

private let logger = Logger(subsystem: "com.bentztech.whitewaterapp", category: "AppDelegate")

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                logger.error("Notification authorization error: \(error.localizedDescription)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        logger.info("Registered for remote notifications with token: \(tokenString)")
        Task {
            await APIService.shared.sendPushToken(tokenString)
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        logger.error("Failed to register for remote notifications: \(error.localizedDescription)")
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification banner, sound, and badge while app is in the foreground
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let notificationType = userInfo["type"] as? String,
           notificationType == "dam_release",
           let damID = userInfo["dam_id"] as? String {
            logger.info("User tapped dam release notification for dam ID: \(damID)")
            NotificationCenter.default.post(
                name: .didReceiveDamReleaseNotification,
                object: nil,
                userInfo: ["dam_id": damID]
            )
        }

        completionHandler()
    }
}

extension Notification.Name {
    static let didReceiveDamReleaseNotification = Notification.Name("didReceiveDamReleaseNotification")
}

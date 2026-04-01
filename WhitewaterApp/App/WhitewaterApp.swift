// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

// Note: @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate is wired below
@main
struct WhitewaterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authService = AuthService.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if authService.isAuthenticated {
                    if authService.isNewUser {
                        OnboardingView()
                    } else {
                        MainTabView()
                    }
                } else {
                    LoginView()
                }
            }
            .environmentObject(authService)
        }
    }
}

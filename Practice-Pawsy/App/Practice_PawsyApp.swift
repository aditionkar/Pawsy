//
//  Practice_PawsyApp.swift
//  Practice-Pawsy
//
//  Created by user@37 on 02/04/26.
//

import SwiftUI

@main
struct Practice_PawsyApp: App {
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if !authVM.isAuthenticated {
                LaunchView()
            } else if authVM.isNewUser {
                // Just registered — go to onboarding
                switch authVM.userRole {
                case "owner":
                    OnboardingView()
                case "walker":
                    WalkersOnboardingView()
                default:
                    ProgressView()
                }
            } else {
                // Returning user — go straight to main
                switch authVM.userRole {
                case "owner":
                    MainTabView()
                case "walker":
                    WalkersMainTabView()
                default:
                    ProgressView()
                }
            }
        }
        .task {
            await authVM.getInitialSession()
        }
    }
}

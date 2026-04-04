//
//  PawsyShortcuts.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import AppIntents

struct PawsyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        
        // MARK: Vaccinations
        AppShortcut(
            intent: UpcomingVaccinationsIntent(),
            phrases: [
                "Show upcoming vaccinations in \(.applicationName)",
                "Tell me upcoming vaccination reminders in \(.applicationName)"
            ],
            shortTitle: "Upcoming Vaccinations",
            systemImageName: "syringe.fill"
        )
        AppShortcut(
            intent: PastVaccinationsIntent(),
            phrases: [
                "Show past vaccinations in \(.applicationName)",
                "Tell me previous vaccination records in \(.applicationName)"
            ],
            shortTitle: "Past Vaccinations",
            systemImageName: "clock.arrow.circlepath"
        )
        
        // MARK: Deworming
        AppShortcut(
            intent: UpcomingDewormingIntent(),
            phrases: [
                "Show upcoming deworming in \(.applicationName)",
                "Tell me deworming reminders in \(.applicationName)"
            ],
            shortTitle: "Upcoming Deworming",
            systemImageName: "drop.fill"
        )
        AppShortcut(
            intent: PastDewormingIntent(),
            phrases: [
                "Show past deworming in \(.applicationName)",
                "Tell me previous deworming records in \(.applicationName)"
            ],
            shortTitle: "Past Deworming",
            systemImageName: "clock.arrow.circlepath"
        )
        
        // MARK: Medication
        AppShortcut(
            intent: UpcomingMedicationIntent(),
            phrases: [
                "Show upcoming medications in \(.applicationName)",
                "Tell me medication reminders in \(.applicationName)",
                "What medicines do I have to give my dog today in \(.applicationName)",
                "What medications does my dog need today in \(.applicationName)"
            ],
            shortTitle: "Upcoming Medications",
            systemImageName: "pills.fill"
        )
        
        // MARK: Grooming
        AppShortcut(
            intent: UpcomingGroomingIntent(),
            phrases: [
                "Show upcoming grooming in \(.applicationName)",
                "Tell me grooming appointments in \(.applicationName)"
            ],
            shortTitle: "Upcoming Grooming",
            systemImageName: "scissors"
        )
    }
}

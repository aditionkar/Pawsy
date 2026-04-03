//
//  VaccinationIntents.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import AppIntents
import SwiftUI

struct UpcomingVaccinationsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Upcoming Vaccinations"
    static var description = IntentDescription("Shows upcoming vaccination reminders in Pawsy.")

    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let reminders = ReminderStore.shared.upcomingVaccinations()
        
        guard !reminders.isEmpty else {
            return .result(dialog: "You have no upcoming vaccinations in Pawsy.", view: EmptyRemindersView())
        }
        return .result(
            dialog: "Here are your upcoming vaccinations.",
            view: ReminderSnippetView(reminders: reminders, mode: .upcoming, category: .vaccinations)
        )
    }
}

struct PastVaccinationsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Past Vaccinations"
    static var description = IntentDescription("Shows past vaccination records in Pawsy.")

    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let reminders = ReminderStore.shared.pastVaccinations()
        
        guard !reminders.isEmpty else {
            return .result(dialog: "You have no past vaccination records in Pawsy.", view: EmptyRemindersView())
        }
        return .result(
            dialog: "Here are your past vaccinations.",
            view: ReminderSnippetView(reminders: reminders, mode: .past, category: .vaccinations)
        )
    }
}

//
//  DewormingIntents.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import AppIntents
import SwiftUI

struct UpcomingDewormingIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Upcoming Deworming"
    static var description = IntentDescription("Shows upcoming deworming reminders in Pawsy.")

    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let reminders = ReminderStore.shared.upcomingDeworming()
        
        guard !reminders.isEmpty else {
            return .result(dialog: "No upcoming deworming reminders in Pawsy.", view: EmptyRemindersView())
        }
        return .result(
            dialog: "Here are your upcoming deworming reminders.",
            view: ReminderSnippetView(reminders: reminders, mode: .upcoming, category: .deworming)
        )
    }
}

struct PastDewormingIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Past Deworming"
    static var description = IntentDescription("Shows past deworming records in Pawsy.")

    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let reminders = ReminderStore.shared.pastDeworming()
        
        guard !reminders.isEmpty else {
            return .result(dialog: "No past deworming records in Pawsy.", view: EmptyRemindersView())
        }
        return .result(
            dialog: "Here are your past deworming records.",
            view: ReminderSnippetView(reminders: reminders, mode: .past, category: .deworming)
        )
    }
}

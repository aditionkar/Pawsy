//
//  GroomingIntents.swift
//  Practice-Pawsy
//
//  Created by user@37 on 04/04/26.
//

import AppIntents
import SwiftUI

struct UpcomingGroomingIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Upcoming Grooming"
    static var description = IntentDescription("Shows upcoming grooming reminders in Pawsy.")

    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let reminders = ReminderStore.shared.upcomingGrooming()
        
        guard !reminders.isEmpty else {
            return .result(dialog: "No upcoming grooming reminders in Pawsy.", view: EmptyRemindersView())
        }
        return .result(
            dialog: "Here are your upcoming grooming appointments.",
            view: ReminderSnippetView(reminders: reminders, mode: .upcoming, category: .grooming)
        )
    }
}

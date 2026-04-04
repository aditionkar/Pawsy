//
//  MedicationIntents.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import AppIntents
import SwiftUI

struct UpcomingMedicationIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Upcoming Medications"
    static var description = IntentDescription("Shows upcoming medication reminders in Pawsy.")

    @MainActor
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let reminders = ReminderStore.shared.upcomingMedication()
        
        guard !reminders.isEmpty else {
            return .result(dialog: "No upcoming medications in Pawsy.", view: EmptyRemindersView())
        }
        return .result(
            dialog: "Here are your upcoming medications.",
            view: ReminderSnippetView(reminders: reminders, mode: .upcoming, category: .medication)
        )
    }
}

//
//  ReminderStore.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import Foundation

class ReminderStore {
    static let shared = ReminderStore()
    
    var reminders: [Reminder] = [
        Reminder(title: "Rabies Booster", subtitle: "Nov 12", category: .vaccinations,
                 nextDate: "Nov 12, 2026", nextTime: "10:00 AM", previousDate: "Nov 12, 2025"),
        Reminder(title: "Full Grooming", subtitle: "9:30 AM", category: .grooming,
                 nextDate: "Tomorrow", previousDate: "Nov 12, 2025", frequency: "Monthly", duration: "2 hours"),
        Reminder(title: "Heartworm Pill", subtitle: "Every 1st", category: .medication,
                 nextTime: "08:00 AM", previousDate: "Nov 12, 2025", dosage: "1 Tablet", frequency: "Monthly"),
        Reminder(title: "Flea Treatment", subtitle: "Due Tomorrow", category: .deworming,
                 nextDate: "April 4", previousDate: "March 4", dosage: "0.5ml")
    ]

    // MARK: - Vaccinations
    func upcomingVaccinations() -> [Reminder] {
        reminders.filter { $0.category == .vaccinations && $0.nextDate != nil }
    }
    func pastVaccinations() -> [Reminder] {
        reminders.filter { $0.category == .vaccinations && $0.previousDate != nil }
    }

    // MARK: - Deworming
    func upcomingDeworming() -> [Reminder] {
        reminders.filter { $0.category == .deworming && $0.nextDate != nil }
    }
    func pastDeworming() -> [Reminder] {
        reminders.filter { $0.category == .deworming && $0.previousDate != nil }
    }

    // MARK: - Medication
    func upcomingMedication() -> [Reminder] {
        reminders.filter { $0.category == .medication && $0.nextDate != nil }
    }
    func pastMedication() -> [Reminder] {
        reminders.filter { $0.category == .medication && $0.previousDate != nil }
    }
}

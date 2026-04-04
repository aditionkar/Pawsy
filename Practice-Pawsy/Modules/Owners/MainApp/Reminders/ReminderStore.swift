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
        Reminder(title: "Rabies Booster", subtitle: "June 12", category: .vaccinations,
                 nextDate: "June 12, 2026", nextTime: "10:00 AM", previousDate: "June 12, 2025"),
        Reminder(title: "Leptospirosis", subtitle: "Aug 3", category: .vaccinations,
                 nextDate: "Aug 3, 2025", nextTime: "9:00 AM", previousDate: "Aug 3, 2025"),
        Reminder(title: "Leptospirosis", subtitle: "May 14", category: .vaccinations,
                 nextDate: "May 14, 2025", nextTime: "8:00 AM", previousDate: "May 14, 2025"),
        Reminder(title: "Nails Trim", subtitle: "9:30 AM", category: .grooming,
                 nextDate: "Tomorrow", previousDate: "Jan 23, 2025", frequency: "Monthly", duration: "30 minutes"),
        Reminder(title: "Haircut", subtitle: "10:30 AM", category: .grooming,
                 nextDate: "Apr 10, 2025", previousDate: "Nov 12, 2025", frequency: "Monthly", duration: "2 hours"),
        Reminder(title: "Heartworm Pill", subtitle: "Every 1st", category: .medication,
                 nextTime: "08:00 AM", previousDate: "March 16, 2025", dosage: "1 Tablet", frequency: "Monthly"),
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

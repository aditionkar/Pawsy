//
//  ReminderSnippetView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

enum SnippetMode { case upcoming, past }

struct ReminderSnippetView: View {
    let reminders: [Reminder]
    let mode: SnippetMode
    let category: ReminderCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(reminders) { reminder in
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(category.iconBg)
                            .frame(width: 36, height: 36)
                        Image(systemName: category.icon)
                            .foregroundColor(category.iconColor)
                            .font(.caption)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(reminder.title)
                            .font(.headline)

                        if mode == .upcoming {
                            HStack(spacing: 6) {
                                if let date = reminder.nextDate {
                                    Label(date, systemImage: "calendar")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                if let time = reminder.nextTime {
                                    Label(time, systemImage: "clock")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else {
                            if let prev = reminder.previousDate {
                                Label(prev, systemImage: "clock.arrow.circlepath")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        // Show dosage for medication & deworming
                        if let dosage = reminder.dosage, category != .vaccinations {
                            Label(dosage, systemImage: "pills.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                if reminder.id != reminders.last?.id {
                    Divider()
                }
            }
        }
        .padding()
    }
}

struct EmptyRemindersView: View {
    var body: some View {
        Text("No reminders found.")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding()
    }
}

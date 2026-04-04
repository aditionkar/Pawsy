//
//  RemindersView.swift
//  Pawsy
//
//  Created by user@37 on 02/04/26.
//

import SwiftUI

enum ReminderCategory: String, CaseIterable {
    case all = "All"
    case vaccinations = "Vaccinations"
    case grooming = "Grooming"
    case deworming = "Deworming"
    case medication = "Medication"
    
    var icon: String {
        switch self {
        case .all: return ""
        case .vaccinations: return "syringe.fill"
        case .grooming: return "scissors"
        case .deworming: return "drop.fill"
        case .medication: return "pills.fill"
        }
    }
    
    var iconBg: Color {
        switch self {
        case .all: return .clear
        case .vaccinations: return Color(.systemBlue).opacity(0.1)
        case .grooming: return Color(.systemYellow).opacity(0.1)
        case .deworming: return Color(.systemTeal).opacity(0.1)
        case .medication: return Color(.systemRed).opacity(0.1)
        }
    }
    
    var iconColor: Color {
        switch self {
        case .all: return .clear
        case .vaccinations: return .blue
        case .grooming: return .yellow
        case .deworming: return .teal
        case .medication: return .red
        }
    }
    
    var selectedPillColor: Color {
        switch self {
        case .all: return Color(.systemOrange)
        case .vaccinations: return .blue
        case .grooming: return .yellow
        case .deworming: return .teal
        case .medication: return .red
        }
    }
}

struct Reminder: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String // Used for the "Normal" card display
    let category: ReminderCategory
    
    // Detailed View Fields
    var nextDate: String?
    var nextTime: String?
    var previousDate: String?
    var dosage: String?
    var frequency: String?
    var duration: String?
}

struct RemindersView: View {
    @State private var selectedCategory: ReminderCategory = .all
    @State private var selectedReminder: Reminder? = nil  // ADD THIS

    var reminders: [Reminder] { ReminderStore.shared.reminders }

    var filteredReminders: [Reminder] {
        if selectedCategory == .all { return reminders }
        return reminders.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ReminderCategory.allCases, id: \.self) { category in
                                Button(action: { selectedCategory = category }) {
                                    CategoryPillView(
                                        title: category.rawValue,
                                        isSelected: selectedCategory == category,
                                        selectedColor: category.selectedPillColor
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: Reminders List
                    VStack(spacing: 16) {
                        ForEach(filteredReminders) { reminder in
                            ReminderCard(
                                title: reminder.title,
                                subtitle: reminder.subtitle,
                                icon: reminder.category.icon,
                                iconBg: reminder.category.iconBg,
                                iconColor: reminder.category.iconColor
                            )
                            .onLongPressGesture {          // CHANGED: was .contextMenu
                                selectedReminder = reminder
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Reminders")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if let reminder = selectedReminder {
                    // Dim background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { selectedReminder = nil }

                    // Floating card
                    DetailedReminderView(reminder: reminder)
                        .frame(width: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        .shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
                        .transition(.scale(scale: 0.92).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: selectedReminder)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: AddVaccinationView()) {
                            Label("Vaccination", systemImage: "syringe.fill")
                        }
                        NavigationLink(destination: AddGroomingView()) {
                            Label("Grooming", systemImage: "scissors")
                        }
                        NavigationLink(destination: AddDewormingView()) {
                            Label("Deworming", systemImage: "drop.fill")
                        }
                        NavigationLink(destination: AddMedicationView()) {
                            Label("Medication", systemImage: "pills.fill")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

struct CategoryPillView: View {
    let title: String
    let isSelected: Bool
    let selectedColor: Color
    
    var body: some View {
        Text(title)
            .font(.system(.body, design: .rounded))
            .fontWeight(.medium)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? selectedColor : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .secondary)
            .clipShape(Capsule())
    }
}

struct ReminderCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconBg: Color
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconBg)
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Image(systemName: subtitleIcon(for: title))
                        .font(.caption)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .font(.title2)
                .foregroundColor(Color(.systemGray4))
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(33)
    }
    
    func subtitleIcon(for title: String) -> String {
        if title.contains("Pill") || title.contains("Treatment") {
            return "arrow.clockwise"
        } else if title.contains("Grooming") {
            return "clock"
        } else {
            return "calendar"
        }
    }
}

struct DetailedReminderView: View {
    let reminder: Reminder

    private var categoryColor: Color { .orange }
    private var categoryIcon: String {
        switch reminder.category {
        case .vaccinations: return "syringe.fill"
        case .deworming:    return "pills.fill"
        case .medication:   return "cross.case.fill"
        case .grooming:     return "scissors"
        case .all:          return "bell.fill"
        }
    }
    private var categoryLabel: String {
        switch reminder.category {
        case .vaccinations: return "Vaccination"
        case .deworming:    return "Deworming"
        case .medication:   return "Medication"
        case .grooming:     return "Grooming"
        case .all:          return "Reminder"
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.orange)
                        .frame(width: 46, height: 46)
                    Image(systemName: categoryIcon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(reminder.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(Color(hex: "#633806"))

                    Text(categoryLabel)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "#854F0B"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: "#FAC775"))
                        .clipShape(Capsule())
                }

                Spacer()
            }
            .padding(20)
            .background(Color(hex: "#FFF3E6"))

            // MARK: Body
            VStack(spacing: 0) {

                // Date pills row
                HStack(spacing: 10) {
                    if let prev = reminder.previousDate {
                        DatePill(label: "Previous", value: prev, isUpcoming: false)
                    }
                    if let next = reminder.nextDate {
                        DatePill(label: "Next due", value: next, isUpcoming: true)
                    }
                }
                .padding(.bottom, 14)

                Divider()

                // Detail rows
                Group {
                    if let time = reminder.nextTime {
                        ReminderDetailRow(icon: "clock.fill", label: "Time", value: time)
                    }

                    switch reminder.category {
                    case .vaccinations:
                        EmptyView()

                    case .deworming:
                        if let dosage = reminder.dosage {
                            ReminderDetailRow(icon: "pills.fill", label: "Dosage", value: dosage)
                        }

                    case .medication:
                        if let dosage = reminder.dosage {
                            ReminderDetailRow(icon: "pills.fill", label: "Dosage", value: dosage)
                        }
                        if let freq = reminder.frequency {
                            ReminderDetailRow(icon: "repeat", label: "Frequency", value: freq)
                        }

                    case .grooming:
                        if let dur = reminder.duration {
                            ReminderDetailRow(icon: "timer", label: "Duration", value: dur)
                        }
                        if let freq = reminder.frequency {
                            ReminderDetailRow(icon: "repeat", label: "Frequency", value: freq)
                        }

                    case .all:
                        EmptyView()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.secondarySystemGroupedBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.bottom, 32)
    }
}

// MARK: - Subviews

struct DatePill: View {
    let label: String
    let value: String
    let isUpcoming: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
                .tracking(0.6)
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(isUpcoming ? Color(hex: "#854F0B") : .primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(14)
    }
}

struct ReminderDetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    RemindersView()
}

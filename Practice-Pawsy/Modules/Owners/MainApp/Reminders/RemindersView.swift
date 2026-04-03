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

struct Reminder: Identifiable {
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
    
    var reminders: [Reminder] { ReminderStore.shared.reminders }
    
    var filteredReminders: [Reminder] {
        if selectedCategory == .all {
            return reminders
        }
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
                            .contextMenu {
                                // This creates the floating detail view on long press
                                DetailedReminderView(reminder: reminder)
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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // MARK: Plus Menu
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(reminder.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Divider()
            
            Group {
                detailRow(label: "Next Date", value: reminder.nextDate)
                detailRow(label: "Time", value: reminder.nextTime)
                
                switch reminder.category {
                case .vaccinations, .deworming:
                    detailRow(label: "Previous Date", value: reminder.previousDate)
                    if reminder.category == .deworming {
                        detailRow(label: "Dosage", value: reminder.dosage)
                    }
                    
                case .medication:
                    detailRow(label: "Dosage", value: reminder.dosage)
                    detailRow(label: "Frequency", value: reminder.frequency)
                    
                case .grooming:
                    detailRow(label: "Duration", value: reminder.duration)
                    detailRow(label: "Frequency", value: reminder.frequency)
                    
                case .all: EmptyView()
                }
            }
        }
        .padding()
        .frame(width: 250) // Standard context menu width
    }
    
    @ViewBuilder
    func detailRow(label: String, value: String?) -> some View {
        if let value = value {
            HStack {
                Text(label).foregroundColor(.secondary)
                Spacer()
                Text(value).fontWeight(.medium)
            }
            .font(.subheadline)
        }
    }
}

#Preview {
    RemindersView()
}

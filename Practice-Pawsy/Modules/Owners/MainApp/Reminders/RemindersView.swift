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
    let subtitle: String
    let badge: String
    let badgeColor: Color
    let category: ReminderCategory
}

struct RemindersView: View {
    @State private var selectedCategory: ReminderCategory = .all
    // 1. State for the floating card
    @State private var inspectedReminder: Reminder? = nil
    
    let reminders: [Reminder] = [
        Reminder(title: "Rabies Booster", subtitle: "Due Nov 12", badge: "OVERDUE", badgeColor: .red, category: .vaccinations),
        Reminder(title: "Full Grooming", subtitle: "9:30 AM", badge: "IN 2 DAYS", badgeColor: .yellow, category: .grooming),
        Reminder(title: "Heartworm Pill", subtitle: "Every 1st of month", badge: "RECURRING", badgeColor: .gray, category: .medication),
        Reminder(title: "Flea Treatment", subtitle: "Due Tomorrow", badge: "UPCOMING", badgeColor: .blue, category: .deworming),
        Reminder(title: "Annual Checkup", subtitle: "Oct 20", badge: "SCHEDULED", badgeColor: .secondary, category: .vaccinations),
    ]
    
    var filteredReminders: [Reminder] {
        if selectedCategory == .all { return reminders }
        return reminders.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Category Filter
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
                        
                        // Reminders List
                        VStack(spacing: 16) {
                            ForEach(filteredReminders) { reminder in
                                ReminderCard(
                                    title: reminder.title,
                                    subtitle: reminder.subtitle,
                                    icon: reminder.category.icon,
                                    iconBg: reminder.category.iconBg,
                                    iconColor: reminder.category.iconColor,
                                    badge: reminder.badge,
                                    badgeColor: reminder.badgeColor
                                )
                                .onLongPressGesture(minimumDuration: 0.5) {
                                    // 2. Trigger floating card
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    withAnimation(.spring()) {
                                        inspectedReminder = reminder
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .navigationTitle("Reminders")
                .background(Color(.systemGroupedBackground))
                
                // 3. Floating Detail Card Overlay
                if let reminder = inspectedReminder {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { inspectedReminder = nil }
                        }
                    
                    FloatingReminderDetail(reminder: reminder) {
                        withAnimation { inspectedReminder = nil }
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .zIndex(1)
                }
            }
        }
    }
}

// MARK: - Floating Detail Component

struct FloatingReminderDetail: View {
    let reminder: Reminder
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with Category Icon
            ZStack {
                Circle()
                    .fill(reminder.category.iconBg)
                    .frame(width: 80, height: 80)
                Image(systemName: reminder.category.icon)
                    .font(.largeTitle)
                    .foregroundColor(reminder.category.iconColor)
            }
            .padding(.top)
            
            VStack(spacing: 8) {
                Text(reminder.title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(reminder.category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(reminder.category.iconColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(reminder.category.iconBg)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            // Details
            VStack(alignment: .leading, spacing: 12) {
                DetailRowView(icon: "calendar", label: "Schedule", value: reminder.subtitle)
                DetailRowView(icon: "tag.fill", label: "Status", value: reminder.badge, valueColor: reminder.badgeColor)
            }
            .padding(.horizontal)
            
            Button(action: onClose) {
                Text("Close")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(15)
            }
            .padding(.top)
        }
        .padding(25)
        .frame(width: 320)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(33)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}

struct DetailRowView: View {
    let icon: String
    let label: String
    let value: String
    var valueColor: Color = .primary
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(valueColor)
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
    let badge: String
    let badgeColor: Color
    
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

#Preview {
    RemindersView()
}

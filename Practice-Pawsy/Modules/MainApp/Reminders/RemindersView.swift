//
//  RemindersView.swift
//  Pawsy
//
//  Created by user@37 on 02/04/26.
//
import SwiftUI

struct Reminder: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let badgeText: String?
    let badgeColor: Color?
}

struct RemindersView: View {
    let categories = ["All", "Vaccinations", "Grooming", "Deworming", "Medication"]
    @State private var selectedCategory = "All"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                if category == "All" {
                                    // "All" stays as a button to filter the list
                                    Button(action: { selectedCategory = category }) {
                                        CategoryPillView(title: category, isSelected: selectedCategory == category)
                                    }
                                } else {
                                    // NavigationLink wrapping a non-button View
                                    NavigationLink(destination: destinationView(for: category)) {
                                        CategoryPillView(title: category, isSelected: false)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: Reminders List
                    VStack(spacing: 16) {
                        // These show for "All"
                        ReminderCard(
                            title: "Rabies Booster",
                            subtitle: "Due Nov 12 • Luna",
                            icon: "syringe.fill",
                            iconBg: Color(.systemBlue).opacity(0.1),
                            iconColor: .blue,
                            badge: "OVERDUE",
                            badgeColor: .red
                        )
                        
                        ReminderCard(
                            title: "Full Grooming",
                            subtitle: "9:30 AM • Charlie",
                            icon: "scissors",
                            iconBg: Color(.systemOrange).opacity(0.1),
                            iconColor: .orange,
                            badge: "IN 2 DAYS",
                            badgeColor: .orange
                        )
                        
                        ReminderCard(
                            title: "Heartworm Pill",
                            subtitle: "Every 1st of month • All Pets",
                            icon: "pills.fill",
                            iconBg: Color(.systemRed).opacity(0.1),
                            iconColor: .red,
                            badge: "RECURRING",
                            badgeColor: .gray
                        )
                        
                        // Adding more cards as requested
                        ReminderCard(
                            title: "Flea Treatment",
                            subtitle: "Due Tomorrow • Miso",
                            icon: "drop.fill",
                            iconBg: Color(.systemTeal).opacity(0.1),
                            iconColor: .teal,
                            badge: "UPCOMING",
                            badgeColor: .blue
                        )
                        
                        ReminderCard(
                            title: "Annual Checkup",
                            subtitle: "Oct 20 • Luna",
                            icon: "stethoscope",
                            iconBg: Color(.systemPurple).opacity(0.1),
                            iconColor: .purple,
                            badge: "SCHEDULED",
                            badgeColor: .secondary
                        )
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
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                    }
                    Button(action: {}) {
                        Image(systemName: "person.circle.fill")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func destinationView(for category: String) -> some View {
        switch category {
        case "Vaccinations":
            AddVaccinationView()
        case "Grooming":
            AddGroomingView()
        case "Deworming":
            AddDewormingView()
        case "Medication":
            AddMedicationView() // Add this line
        default:
            VStack {
                Text("Add \(category) Screen")
                    .font(.headline)
            }
            .navigationTitle(category)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Subviews

// Renamed and changed to a simple View (removed the internal Button)
struct CategoryPillView: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(.body, design: .rounded))
            .fontWeight(.medium)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? Color(.systemOrange) : Color(.systemGray5))
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
                HStack {
                    Text(title)
                        .font(.headline)
                    
                    Text(badge)
                        .font(.caption2.bold())
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(badgeColor.opacity(0.15))
                        .foregroundColor(badgeColor)
                        .cornerRadius(4)
                }
                
                HStack(spacing: 4) {
                    if title.contains("Pill") || title.contains("Treatment") {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                    } else if title.contains("Grooming") {
                        Image(systemName: "clock")
                            .font(.caption)
                    } else {
                        Image(systemName: "calendar")
                            .font(.caption)
                    }
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
}

#Preview {
    RemindersView()
}

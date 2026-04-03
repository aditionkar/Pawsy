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
                    
                    // MARK: Description Header
                    Text("Manage your pet's health and wellness schedule.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // MARK: Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryPill(
                                    title: category,
                                    isSelected: selectedCategory == category,
                                    action: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: Reminders List
                    VStack(spacing: 16) {
                        ReminderCard(
                            title: "Rabies Booster",
                            subtitle: "Due Nov 12 • Luna",
                            icon: "syringe.fill",
                            iconBg: Color(.systemBlue).opacity(0.1),
                            iconColor: Color(.systemBlue),
                            badge: "OVERDUE",
                            badgeColor: .red
                        )
                        
                        ReminderCard(
                            title: "Full Grooming",
                            subtitle: "9:30 AM • Charlie",
                            icon: "scissors",
                            iconBg: Color(.systemOrange).opacity(0.1),
                            iconColor: Color(.systemOrange),
                            badge: "IN 2 DAYS",
                            badgeColor: .orange
                        )
                        
                        ReminderCard(
                            title: "Heartworm Pill",
                            subtitle: "Every 1st of month • All Pets",
                            icon: "pills.fill",
                            iconBg: Color(.systemRed).opacity(0.1),
                            iconColor: Color(.systemRed),
                            badge: "RECURRING",
                            badgeColor: .gray
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
}

// MARK: - Subviews

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
                    if title.contains("Pill") {
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
        .cornerRadius(20)
    }
}

#Preview {
    RemindersView()
}

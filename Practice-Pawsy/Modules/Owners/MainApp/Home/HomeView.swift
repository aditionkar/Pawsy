//
//  HomeView.swift
//  Pawsy
//
//  Created by user@37 on 02/04/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
   
    let ownerName = "Rahul"
    let petName = "Buddy"
    let petBreed = "Golden Retriever"
    let petAge = "2 years"
    let petImage: UIImage? = nil

    let todayReminders: [Reminder] = [
        Reminder(title: "Rabies Booster", subtitle: "Due Nov 12", badge: "OVERDUE", badgeColor: .red, category: .vaccinations),
        Reminder(title: "Full Grooming", subtitle: "9:30 AM", badge: "IN 2 DAYS", badgeColor: .yellow, category: .grooming),
        Reminder(title: "Heartworm Pill", subtitle: "Every 1st of month", badge: "RECURRING", badgeColor: .gray, category: .medication),
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Pet Card
                    PetCardView(
                        petName: petName,
                        petBreed: petBreed,
                        petAge: petAge,
                        petImage: petImage
                    )
                    .padding(.horizontal)

                    // MARK: Today's Summary
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Today's Summary")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(todayReminders.count) tasks")
                                .font(.system(size: 13, weight: .regular, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)

                        if todayReminders.isEmpty {
                            EmptySummaryView()
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(todayReminders) { reminder in
                                    HomeReminderRow(reminder: reminder)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Greeting — left
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Hey, \(ownerName) 👋")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            Task {
                                await authViewModel.signOut()
                            }
                        } label: {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle") // The "eclipse" (ellipsis) symbol
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}

// MARK: - Pet Card

struct PetCardView: View {
    let petName: String
    let petBreed: String
    let petAge: String
    let petImage: UIImage?

    var body: some View {
        HStack(spacing: 16) {
            // Pet photo
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemOrange).opacity(0.1))
                    .frame(width: 80, height: 80)

                if let image = petImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Image(systemName: "dog.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(.systemOrange).opacity(0.6))
                }
            }

            // Pet info
            VStack(alignment: .leading, spacing: 4) {
                Text(petName)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(petBreed)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "birthday.cake")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text(petAge)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 2)
            }

            Spacer()

            // Arrow
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(.systemOrange))
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

// MARK: - Home Reminder Row

struct HomeReminderRow: View {
    let reminder: Reminder
    @State private var isDone = false

    var body: some View {
        HStack(spacing: 16) {
            // Category icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(reminder.category.iconBg)
                    .frame(width: 50, height: 50)
                Image(systemName: reminder.category.icon)
                    .foregroundColor(reminder.category.iconColor)
                    .font(.title3)
            }

            // Title + subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(isDone ? .secondary : .primary)
                    .strikethrough(isDone, color: .secondary)

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(reminder.subtitle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }

                // Badge
                Text(reminder.badge)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(reminder.badgeColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(reminder.badgeColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Spacer()

            // Checkmark
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isDone.toggle()
                }
            }) {
                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isDone ? Color(.systemOrange) : Color(.systemGray4))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .opacity(isDone ? 0.6 : 1)
    }
}

// MARK: - Empty State

struct EmptySummaryView: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemOrange).opacity(0.1))
                    .frame(width: 50, height: 50)
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemOrange))
                    .font(.title3)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("All clear!")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Text("No tasks for today")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

#Preview {
    HomeView()
}

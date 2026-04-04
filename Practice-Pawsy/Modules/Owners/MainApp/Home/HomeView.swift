//
//  HomeView.swift
//  Pawsy
//
//  Created by user@37 on 02/04/26.
//

import SwiftUI
internal import Auth

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
   
    let petName = "Buddy"
    let petBreed = "Golden Retriever"
    let petAge = "2 years • 32 Kg"
    let petImage: UIImage? = nil

    let todayReminders: [Reminder] = [
        
        // Grooming: service name, duration, date, and frequency
        Reminder(
            title: "Nails Trim",
            subtitle: "9:30 AM",
            category: .grooming,
            nextDate: "April 4, 2026",
            nextTime: "6:30 pM",
            frequency: "Monthly",
            duration: "30 minutes"
        ),
        
        // Medication: medicine name, dosage, frequency, and next date/time
        Reminder(
            title: "Heartworm Pill",
            subtitle: "Every 4th of month",
            category: .medication,
            nextDate: "May 4, 2026",
            nextTime: "05:00 PM",
            dosage: "1 Tablet (25mg)",
            frequency: "Monthly"
        )
    ]

    let suggestions: [Suggestion] = [
        Suggestion(icon: "pawprint", title: "Take your dog for a walk", subtitle: "Book a pet walker", color: .blue, action: "walk"),
        Suggestion(icon: "house.fill", title: "Busy for a day?", subtitle: "Book a pet sitter", color: .purple, action: "sitter")
    ]
    
    // MARK: - Computed Properties
    
    // Extract first name from email
    var ownerName: String {
        guard let email = authViewModel.currentUser?.email else {
            return "Pet Parent"
        }
        
        // Get the part before @
        let emailPrefix = email.split(separator: "@").first?.lowercased() ?? ""
        
        // Split by common separators and take first part
        let nameParts = emailPrefix.split { $0 == "." || $0 == "_" || $0 == "-" }
        
        if let firstName = nameParts.first {
            return firstName.capitalized
        }
        
        return emailPrefix.capitalized
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Pet Card (Now Navigates to PetProfileView)
                    NavigationLink(destination: PetProfileView()) {
                        PetCardView(
                            petName: petName,
                            petBreed: petBreed,
                            petAge: petAge,
                            petImage: petImage
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
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
                    
                    // MARK: Need a Hand?
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Need a Hand? 🐾")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Horizontal scroll of square cards
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(suggestions) { suggestion in
                                    SquareSuggestionCard(suggestion: suggestion)
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
            .navigationTitle("Hey, \(ownerName) 👋")
            
            .toolbar {
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
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}

// MARK: - Square Suggestion Card

struct SquareSuggestionCard: View {
    let suggestion: Suggestion
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Handle suggestion action
            print("Tapped: \(suggestion.action)")
        }) {
            VStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(suggestion.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Image(systemName: suggestion.icon)
                        .font(.system(size: 32))
                        .foregroundColor(suggestion.color)
                }
                
                // Text
                VStack(spacing: 8) {
                    Text(suggestion.title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(suggestion.subtitle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer(minLength: 0)
            }
            .padding(20)
            .frame(width: 177, height: 177)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 33))
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Suggestion Model

struct Suggestion: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: String
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
                    Image("dog1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
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

            // Arrow indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(.systemOrange))
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

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(reminder.subtitle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }
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
        .environmentObject(AuthViewModel())
}

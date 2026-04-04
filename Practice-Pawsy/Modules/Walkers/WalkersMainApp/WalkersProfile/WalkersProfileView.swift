//
//  WalkersProfileView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI
internal import Auth

struct WalkersProfileView: View {
    @State private var notificationsEnabled = true
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Availability state variables
    @State private var selectedDays: Set<String> = ["MON", "THU", "SAT"]
    @State private var fromTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var toTime = Calendar.current.date(from: DateComponents(hour: 18, minute: 0)) ?? Date()
    @State private var isAvailableOnShortNotice = true
    @State private var showEditAvailability = false
    
    var ownerName: String {
        guard let email = authViewModel.currentUser?.email else {
            return "Pet Parent"
        }
        let emailPrefix = email.split(separator: "@").first?.lowercased() ?? ""
        let nameParts = emailPrefix.split { $0 == "." || $0 == "_" || $0 == "-" }
        if let firstName = nameParts.first {
            return firstName.capitalized
        }
        return emailPrefix.capitalized
    }

    var initials: String {
        String(ownerName.prefix(2)).uppercased()
    }
    
    // Computed properties for displaying availability
    var weekdayAvailability: String {
        let weekdays = ["MON", "TUE", "WED", "THU", "FRI"]
        let selectedWeekdays = weekdays.filter { selectedDays.contains($0) }
        if selectedWeekdays.count == 5 {
            return "Mon — Fri"
        } else if !selectedWeekdays.isEmpty {
            return selectedWeekdays.joined(separator: ", ").capitalized
        }
        return "No weekdays selected"
    }
    
    var weekendAvailability: String {
        let weekends = ["SAT", "SUN"]
        let selectedWeekends = weekends.filter { selectedDays.contains($0) }
        if selectedWeekends.count == 2 {
            return "Sat — Sun"
        } else if !selectedWeekends.isEmpty {
            return selectedWeekends.joined(separator: ", ").capitalized
        }
        return "No weekends selected"
    }
    
    var formattedFromTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: fromTime)
    }
    
    var formattedToTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: toTime)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Header Section
                        VStack(spacing: 8) {
                            Text(initials)
                                .font(.system(size: 32, weight: .bold))
                                .frame(width: 100, height: 100)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.brown)
                                .clipShape(RoundedRectangle(cornerRadius: 25))

                            Text(ownerName)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Chennai, Tamil Nadu")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)

                        // MARK: - Stats Row
                        HStack(spacing: 12) {
                            StatBox(number: "42", label: "Walks")
                            StatBox(number: "18", label: "Sits")
                            StatBox(number: "4.9 ★", label: "Rating")
                        }
                        .padding(.horizontal)

                        // MARK: - Availability Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Avalability", showEdit: true) {
                                showEditAvailability = true
                            }
                            
                            VStack(spacing: 16) {
                                AvailabilityRow(
                                    days: weekdayAvailability,
                                    time: "\(formattedFromTime) - \(formattedToTime)"
                                )
                                AvailabilityRow(
                                    days: weekendAvailability,
                                    time: "\(formattedFromTime) - \(formattedToTime)"
                                )
                                
                                if isAvailableOnShortNotice {
                                    HStack {
                                        Image(systemName: "bolt.fill")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                        Text("Available on short notice")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                        Spacer()
                                    }
                                    .padding(.top, 8)
                                }
                            }
                            .padding(25)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(33)
                        }
                        .padding(.horizontal)

                        // MARK: - Settings Section
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Settings", showEdit: false) {
                                // No action needed
                            }
                            
                            VStack(spacing: 0) {
                                Toggle(isOn: $notificationsEnabled) {
                                    Label("Notifications", systemImage: "bell.fill")
                                        .fontWeight(.medium)
                                }
                                .tint(.orange)
                                .padding()
                                
                                Divider().padding(.leading, 50)
                                
                                Button(action: {
                                    Task {
                                        await authViewModel.signOut()
                                    }
                                }) {
                                    HStack {
                                        Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                    .foregroundColor(.red)
                                    .padding()
                                }
                            }
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(33)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showEditAvailability) {
                EditAvailabilityView(
                    selectedDays: $selectedDays,
                    fromTime: $fromTime,
                    toTime: $toTime,
                    isAvailableOnShortNotice: $isAvailableOnShortNotice
                )
            }
        }
    }
}

// MARK: - Updated Subviews

struct SectionHeader: View {
    let title: String
    let showEdit: Bool
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .tracking(1.2)
            
            Spacer()
            
            if showEdit {
                Button(action: onEdit) {
                    Text("Edit")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.brown)
                }
            }
        }
    }
}

struct StatBox: View {
    let number: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}

struct AvailabilityRow: View {
    let days: String
    let time: String
    
    var body: some View {
        HStack {
            Text(days)
                .fontWeight(.medium)
            Spacer()
            Text(time)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.orange.opacity(0.8))
        }
    }
}

#Preview {
    WalkersProfileView()
        .environmentObject(AuthViewModel())
}

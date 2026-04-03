//
//  WalkersProfileView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkersProfileView: View {
    @State private var notificationsEnabled = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Header Section
                        VStack(spacing: 8) {
                            Text("JS")
                                .font(.system(size: 32, weight: .bold))
                                .frame(width: 100, height: 100)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.brown)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                            Text("Julianne Smith")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("SAN FRANCISCO, CA")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)

                        // MARK: - Stats Row
                        HStack(spacing: 12) {
                            StatBox(number: "142", label: "WALKS")
                            StatBox(number: "28", label: "SITS")
                            StatBox(number: "4.9 ★", label: "RATING")
                        }
                        .padding(.horizontal)

                        // MARK: - Availability Section
                        VStack(alignment: .leading, spacing: 12) {
                            // Show edit button here
                            SectionHeader(title: "AVAILABILITY", showEdit: true)
                            
                            VStack(spacing: 16) {
                                AvailabilityRow(days: "Mon — Fri", time: "08:00 AM - 06:00 PM")
                                AvailabilityRow(days: "Sat — Sun", time: "10:00 AM - 04:00 PM")
                            }
                            .padding(25)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(33)
                        }
                        .padding(.horizontal)

                        // MARK: - Settings Section
                        VStack(alignment: .leading, spacing: 12) {
                            // No edit button here
                            SectionHeader(title: "SETTINGS", showEdit: false)
                            
                            VStack(spacing: 0) {
                                Toggle(isOn: $notificationsEnabled) {
                                    Label("Notifications", systemImage: "bell.fill")
                                        .fontWeight(.medium)
                                }
                                .tint(.orange)
                                .padding()
                                
                                Divider().padding(.leading, 50)
                                
                                Button(action: { /* Log out logic */ }) {
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
        }
    }
}

// MARK: - Updated Subviews

struct SectionHeader: View {
    let title: String
    let showEdit: Bool // Toggle visibility of the Edit button
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .tracking(1.2)
            
            Spacer()
            
            if showEdit {
                Button("Edit") { }
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.brown)
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
                .fontWeight(.bold)
            Spacer()
            Text(time)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange.opacity(0.8))
        }
    }
}

#Preview {
    WalkersProfileView()
}

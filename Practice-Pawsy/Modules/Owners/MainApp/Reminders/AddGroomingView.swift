//
//  AddGroomingView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//
import SwiftUI

struct AddGroomingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groomingType = ""
    @State private var date = Date()
    @State private var notes = ""
    
    // Duration in minutes
    @State private var durationMinutes = 30
    
    // Reminder States
    @State private var repeatReminders = true
    @State private var selectedFrequency = "Weekly" // "Weekly" or "Monthly"

    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Grooming Details")) {
                    TextField("Service Type (e.g. Full Groom, Nail Trim)", text: $groomingType)
                    
                    // Date picker without time
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    // Duration Picker (15 min intervals)
                    HStack {
                        Text("Duration")
                        Spacer()
                        Stepper(value: $durationMinutes, in: 15...480, step: 15) {
                            Text(formatDuration(durationMinutes))
                                .foregroundColor(.orange)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Section(header: Text("Notes")) {
                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Describe the service...")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .padding(.horizontal, -4)
                    }
                }
                
                // MARK: Reminders Section
                Section(header: Text("REMINDERS").font(.caption)) {
                    Toggle(isOn: $repeatReminders.animation()) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Repeat Reminders")
                        }
                    }
                    .tint(.orange)
                    
                    if repeatReminders {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 16) {
                                FrequencyPill(title: "Weekly", isSelected: selectedFrequency == "Weekly") {
                                    selectedFrequency = "Weekly"
                                }
                                
                                FrequencyPill(title: "Monthly", isSelected: selectedFrequency == "Monthly") {
                                    selectedFrequency = "Monthly"
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section {
                    Color.clear.frame(height: 80)
                }
                .listRowBackground(Color.clear)
            }
            
            // MARK: Floating Action Button
            VStack {
                Button(action: { dismiss() }) {
                    HStack {
                        Text("Add Grooming ")
                        Image(systemName: "checkmark.circle")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGroupedBackground).opacity(0), Color(.systemGroupedBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)
            )
        }
        .navigationTitle("Add Grooming")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // Helper to format minutes into "1hr 15mins" style
    func formatDuration(_ mins: Int) -> String {
        let hours = mins / 60
        let minutes = mins % 60
        if hours > 0 {
            return minutes > 0 ? "\(hours)h \(minutes)m" : "\(hours)h"
        }
        return "\(minutes)m"
    }
}

// MARK: - Frequency Pill Subview
struct FrequencyPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.orange.opacity(0.1) : Color(.systemGray6))
                .foregroundColor(isSelected ? .orange : Color(.label))
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 1)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        AddGroomingView()
    }
}

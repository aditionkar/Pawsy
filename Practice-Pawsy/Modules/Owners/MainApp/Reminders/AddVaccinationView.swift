//
//  AddVaccinationView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//
import SwiftUI

struct AddVaccinationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var petName = ""
    @State private var vaccineType = ""
    @State private var date = Date()
    @State private var notes = ""
    
    // Reminder States
    @State private var setReminder = true
    @State private var reminderDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var reminderTime = Date()

    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Vaccination Details")) {
                    TextField("Select Vaccine", text: $vaccineType)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .accentColor(.orange)
                }
                
                Section(header: Text("Notes")) {
                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Add optional details about the appointment, reaction, or clinic...")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            // This slight offset helps align the text with the placeholder
                            .padding(.horizontal, -4)
                    }
                }
                
                // MARK: Reminders Section
                Section(header: Text("REMINDERS").font(.caption)) {
                    Toggle(isOn: $setReminder.animation()) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Set Next Reminder")
                        }
                    }
                    .tint(.orange)
                    
                    if setReminder {
                        DatePicker(
                            "Reminder Date",
                            selection: $reminderDate,
                            displayedComponents: .date
                        )
                        .accentColor(.orange)
                        DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                            .accentColor(.orange)
                        
                    }
                }
                
                // Empty spacer to prevent content from being hidden behind the fixed button
                Section {
                    Color.clear.frame(height: 80)
                }
                .listRowBackground(Color.clear)
            }
            
            // MARK: Floating Action Button
            VStack {
                Button(action: {
                    // Save logic here
                    dismiss()
                }) {
                    HStack {
                        Text("Add Vaccine Record")
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
                .padding(.bottom, 10) // Positioned at the very bottom
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
        .navigationTitle("Add Vaccination")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        AddVaccinationView()
    }
}

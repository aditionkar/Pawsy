//
//  AddMedicationView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var medicineName = ""
    @State private var dosage = ""
    @State private var frequency = "Daily"
    @State private var startDate = Date()
    @State private var notes = ""
    
    let frequencies = ["Daily", "Twice a Day", "Weekly", "Monthly"]
    
    // Reminder States
    @State private var setReminder = true
    @State private var reminderTime1 = Date()
    @State private var reminderTime2 = Date()
    @State private var selectedDayOfWeek = "Monday"
    @State private var monthlyDate = Date()
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medicine Name (e.g. Apoquel)", text: $medicineName)
                    TextField("Dosage (e.g. 1/2 tablet, 2ml)", text: $dosage)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(frequencies, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Instructions / Notes")) {
                    ZStack(alignment: .topLeading) {
                        if notes.isEmpty {
                            Text("Add instructions (e.g. give with food)...")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $notes)
                            .frame(height: 80)
                            .padding(.horizontal, -4)
                    }
                }
                
                // MARK: Dynamic Reminders Section
                Section(header: Text("REMINDERS").font(.caption)) {
                    Toggle(isOn: $setReminder.animation()) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Enable Dose Notifications")
                        }
                    }
                    .tint(.orange)
                    
                    if setReminder {
                        Group {
                            switch frequency {
                            case "Daily":
                                DatePicker("Reminder Time", selection: $reminderTime1, displayedComponents: .hourAndMinute)
                                    .accentColor(.orange)
                                
                            case "Twice a Day":
                                DatePicker("First Dose", selection: $reminderTime1, displayedComponents: .hourAndMinute)
                                    .accentColor(.orange)
                                DatePicker("Second Dose", selection: $reminderTime2, displayedComponents: .hourAndMinute)
                                    .accentColor(.orange)
                                
                            case "Weekly":
                                Picker("Day of the Week", selection: $selectedDayOfWeek) {
                                    ForEach(daysOfWeek, id: \.self) { day in
                                        Text(day).tag(day)
                                    }
                                }
                                DatePicker("Reminder Time", selection: $reminderTime1, displayedComponents: .hourAndMinute)
                                    .accentColor(.orange)
                                
                            case "Monthly":
                                DatePicker("Day of Month", selection: $monthlyDate, displayedComponents: .date)
                                    .accentColor(.orange)
                                DatePicker("Reminder Time", selection: $reminderTime1, displayedComponents: .hourAndMinute)
                                    .accentColor(.orange)
                                
                            default:
                                EmptyView()
                            }
                        }
                        .accentColor(.orange)
                    }
                }
                
                Section {
                    Color.clear.frame(height: 80)
                }
                .listRowBackground(Color.clear)
            }
            
            // MARK: Floating Action Button
            VStack {
                Button(action: {
                    // Logic to save based on frequency would go here
                    dismiss()
                }) {
                    HStack {
                        Text("Add Medication Record")
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
        .navigationTitle("Add Medication")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        AddMedicationView()
    }
}

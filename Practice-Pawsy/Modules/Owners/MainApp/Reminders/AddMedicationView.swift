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
    @State private var reminderTime = Date()

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
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
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
                
                // MARK: Reminders Section
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
                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
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
                    dismiss()
                }) {
                    HStack {
                        Text("Add Medication Record")
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
        .navigationTitle("Add Medication")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.bold)
                .foregroundColor(.orange)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddMedicationView()
    }
}

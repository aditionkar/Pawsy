//
//  AddDewormingView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct AddDewormingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var medicationName = ""
    @State private var dosage = ""
    @State private var lastDate = Date()
    
    // Reminder States
    @State private var setReminder = true
    @State private var reminderDate = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()

    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section(header: Text("Deworming Details")) {
                    TextField("Medication Name (e.g. Drontal)", text: $medicationName)
                    TextField("Dosage (e.g. 1 tablet / 5ml)", text: $dosage)
                    DatePicker("Last Deworming Date", selection: $lastDate, displayedComponents: .date)
                }
                
                // MARK: Reminders Section
                Section(header: Text("REMINDERS").font(.caption)) {
                    Toggle(isOn: $setReminder.animation()) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Set Next Dose Reminder")
                        }
                    }
                    .tint(.orange)
                    
                    if setReminder {
                        DatePicker(
                            "Next Dose Date",
                            selection: $reminderDate,
                            displayedComponents: .date
                        )
                        .accentColor(.orange)
                    }
                }
                
                // Spacer to ensure scrollability above the button
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
                        Text("Add Deworming Record")
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
        .navigationTitle("Add Deworming")
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
        AddDewormingView()
    }
}

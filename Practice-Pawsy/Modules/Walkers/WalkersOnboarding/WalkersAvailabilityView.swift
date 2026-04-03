//
//  WalkersAvailabilityView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkersAvailabilityView: View {
    @Environment(\.dismiss) var dismiss
    
    // State for day selection (Mon, Wed, Thu selected by default)
    @State private var selectedDays: Set<String> = []
    let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    @State private var fromTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var toTime = Calendar.current.date(from: DateComponents(hour: 18, minute: 30)) ?? Date()
    @State private var isAvailableOnShortNotice = true
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Text("When are you available?")
                            .font(.system(size: 28, weight: .bold))
                            .padding(.top, 20)
                            .padding(.horizontal)
                        
                        // MARK: - Select Work Days
                        VStack(alignment: .leading, spacing: 15) {
                            Text("SELECT WORK DAYS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(days, id: \.self) { day in
                                        DayOnlyCard(day: day, isSelected: selectedDays.contains(day)) {
                                            if selectedDays.contains(day) {
                                                selectedDays.remove(day)
                                            } else {
                                                selectedDays.insert(day)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // MARK: - Time Range
                        VStack(alignment: .leading, spacing: 15) {
                            Text("TIME RANGE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 15) {
                                TimeSelectorCard(label: "From", selection: $fromTime)
                                TimeSelectorCard(label: "To", selection: $toTime)
                            }
                        }
                        
                        // MARK: - Short Notice Toggle
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Available on short notice")
                                        .font(.headline)
                                    Text("Accept walks with < 2h lead time")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isAvailableOnShortNotice)
                                    .tint(.orange)
                                    .labelsHidden()
                            }
                            .padding(25)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(33)
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding()
                }
                
                // MARK: - Save Button
                Button(action: { dismiss() }) {
                    Text("Save Availability")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.orange)
                        .cornerRadius(33)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(uiColor: .systemGroupedBackground).opacity(0), Color(uiColor: .systemGroupedBackground)]), startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                )
            }
        }
    }
}

// MARK: - Simplified Day Card (No Dates)
struct DayOnlyCard: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 70, height: 70) // Square-ish design
                .background(isSelected ? Color.orange : Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(20)
        }
    }
}

struct TimeSelectorCard: View {
    let label: String
    @Binding var selection: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            DatePicker("", selection: $selection, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.compact)
                .tint(.orange)
                .scaleEffect(1.1) // Slightly larger for easier tapping
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(25)
    }
}

#Preview {
    WalkersAvailabilityView()
}

//
//  EditAvailabilityView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 04/04/26.
//

import SwiftUI

struct EditAvailabilityView: View {
    @Binding var selectedDays: Set<String>
    @Binding var fromTime: Date
    @Binding var toTime: Date
    @Binding var isAvailableOnShortNotice: Bool
    @Environment(\.dismiss) var dismiss
    
    let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    Text("Edit Availability")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 20)
                        .padding(.horizontal)
                    
                    // MARK: - Select Work Days
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Select Work Days")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(days, id: \.self) { day in
                                    DayCard(day: day, isSelected: selectedDays.contains(day)) {
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
                    .padding(.horizontal)
                    
                    // MARK: - Time Range
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Time Range")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 15) {
                            TimeSelector(label: "From", selection: $fromTime)
                            TimeSelector(label: "To", selection: $toTime)
                        }
                    }
                    .padding(.horizontal)
                    
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
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                }
            }
        }
    }
}

struct DayCard: View {
    let day: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(day)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .primary)
                .frame(width: 70, height: 70)
                .background(isSelected ? Color.orange : Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(35)
        }
    }
}

struct TimeSelector: View {
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
                .scaleEffect(1.1)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(25)
    }
}

#Preview {
    EditAvailabilityView(
        selectedDays: .constant(["MON", "WED", "FRI"]),
        fromTime: .constant(Date()),
        toTime: .constant(Date()),
        isAvailableOnShortNotice: .constant(true)
    )
}

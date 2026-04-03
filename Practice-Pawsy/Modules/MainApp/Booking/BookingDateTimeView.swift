//
//  BookingDateTimeView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//
import SwiftUI

struct BookingDateTimeView: View {
    let serviceTitle: String
    
    // Compute the dynamic dates once when the view initializes
    private var dates: [(day: String, num: String, month: String)] {
        let calendar = Calendar.current
        let now = Date()
        
        return (0...2).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: now) ?? now
            let dayLabel: String
            
            switch offset {
            case 0: dayLabel = "TODAY"
            case 1: dayLabel = "TOM"
            default:
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE" // e.g., "FRI"
                dayLabel = formatter.string(from: date).uppercased()
            }
            
            let numFormatter = DateFormatter()
            numFormatter.dateFormat = "d"
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MMM"
            
            return (
                day: dayLabel,
                num: numFormatter.string(from: date),
                month: monthFormatter.string(from: date).uppercased()
            )
        }
    }
    
    @State private var selectedDate: String
    @State private var selectedTime = Date()
    @State private var selectedDuration = "30 min"

    init(serviceTitle: String) {
        self.serviceTitle = serviceTitle
        // Initialize selectedDate with today's date number
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        _selectedDate = State(initialValue: formatter.string(from: Date()))
    }
    
    var durations: [String] {
        serviceTitle.contains("Walk") ? ["20 min", "30 min", "45 min"] : ["1 hour", "2 hours", "Overnight"]
    }
    
    var buttonLabel: String {
        serviceTitle.contains("Walk") ? "See Available Walkers" : "See Available Sitters"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // MARK: Select Date
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Date")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 12) {
                            ForEach(dates, id: \.num) { date in
                                DateSelectionCard(
                                    day: date.day,
                                    number: date.num,
                                    month: date.month,
                                    isSelected: selectedDate == date.num,
                                    action: { selectedDate = date.num }
                                )
                            }
                        }
                    }
                    
                    // MARK: Select Time
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Time")
                            .font(.system(.headline, design: .rounded))
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                            
                            Text("Set Appointment Time")
                                .font(.system(.subheadline, design: .rounded))
                            
                            Spacer()
                            
                            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .tint(.orange)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(20)
                    }
                    
                    // MARK: Duration
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Duration")
                            .font(.system(.headline, design: .rounded))
                        
                        HStack(spacing: 12) {
                            ForEach(durations, id: \.self) { duration in
                                DurationPill(
                                    title: duration,
                                    isSelected: selectedDuration == duration,
                                    action: { selectedDuration = duration }
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            
            // MARK: Fixed Bottom Navigation Link
                        NavigationLink(destination: ChooseWalkersSittersView(
                            serviceTitle: serviceTitle,
                            selectedDate: selectedDate,
                            selectedTime: selectedTime,
                            selectedDuration: selectedDuration
                        )) {
                            HStack {
                                Text(buttonLabel)
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(.headline, design: .rounded).bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.orange)
                            .clipShape(Capsule())
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                        .background(Color(.systemGroupedBackground))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(serviceTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Subviews

struct DateSelectionCard: View {
    let day: String; let number: String; let month: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(day).font(.system(.caption2, design: .rounded).bold())
                Text(number).font(.system(.title2, design: .rounded).bold())
                Text(month).font(.system(.caption2, design: .rounded).bold())
            }
            .foregroundColor(isSelected ? .white : .secondary)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity) // KEY CHANGE: Removes fixed width, allows expansion
            .frame(height: 105)
            .background(isSelected ? Color.orange : Color(.secondarySystemGroupedBackground))
            .cornerRadius(24)
        }
    }
}

struct DurationPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .rounded).bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity) // Also expanded these to match the "full width" look
                .background(isSelected ? Color.orange.opacity(0.1) : Color(.secondarySystemGroupedBackground))
                .foregroundColor(isSelected ? .orange : .primary)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                )
                .clipShape(Capsule())
        }
    }
}

#Preview {
    NavigationStack {
        BookingDateTimeView(serviceTitle: "Book a Walk")
    }
}

//.toolbar(.hidden, for: .tabBar)

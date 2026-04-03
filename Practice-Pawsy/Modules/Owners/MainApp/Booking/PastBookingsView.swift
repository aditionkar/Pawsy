//
//  PastBookingsView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct PastBookingRecord: Identifiable {
    let id = UUID()
    let walkerName: String
    let date: String
    let service: String
    let amount: String
}

struct PastBookingsView: View {
    let pastBookings = [
        PastBookingRecord(walkerName: "Aman Gupta", date: "Mar 28, 2026", service: "Dog Walking", amount: "$25.00"),
        PastBookingRecord(walkerName: "Sana Sheikh", date: "Mar 22, 2026", service: "Pet Sitting", amount: "$45.00"),
        PastBookingRecord(walkerName: "Riya Sengupta", date: "Mar 15, 2026", service: "Dog Walking", amount: "$25.00")
    ]
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(pastBookings) { booking in
                        PastBookingCard(booking: booking)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Past Bookings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PastBookingCard: View {
    let booking: PastBookingRecord
    
    var body: some View {
        HStack(spacing: 16) {
            // Smaller, subtle icon for history
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 45, height: 45)
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.walkerName)
                    .font(.system(.headline, design: .rounded))
                
                Text("\(booking.service) • \(booking.date)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(booking.amount)
                    .font(.system(.subheadline, design: .rounded).bold())
                
                Text("Completed")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(33) // Consistent corner radius
    }
}

#Preview {
    NavigationStack {
        PastBookingsView()
    }
}

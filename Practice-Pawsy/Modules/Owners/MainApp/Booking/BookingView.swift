//
//  BookingView.swift
//  Pawsy
//
//  Created by user@37 on 02/04/26.
//
import SwiftUI

struct BookingView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // MARK: Booking Options
                    VStack(spacing: 20) {
                        NavigationLink(destination: BookingDateTimeView(serviceTitle: "Book a Walk")) {
                            BookingCardView(
                                title: "Book a Walk",
                                description: "Up to 45 min guided outing",
                                actionText: "Start Schedule",
                                icon: "pawprint.fill"
                            )
                        }

                        NavigationLink(destination: BookingDateTimeView(serviceTitle: "Book a Sitter")) {
                            BookingCardView(
                                title: "Book a Sitter",
                                description: "In-home pet care at your place",
                                actionText: "View Availability",
                                icon: "house.fill"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Upcoming Bookings Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Upcoming Bookings")
                            .font(.system(.title2, design: .rounded).bold())
                            .padding(.horizontal)
                        
                        UpcomingBookingCard(
                            walkerName: "Riya Sengupta",
                            time: "Today, 6:00 PM",
                            service: "Dog Walking",
                            image: "person.circle.fill"
                        )
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Book a Service")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: PastBookingsView()) {
                        Image(systemName: "clock.arrow.circlepath")
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

struct UpcomingBookingCard: View {
    let walkerName: String
    let time: String
    let service: String
    let image: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            Image(systemName: image)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray.opacity(0.4))
                .background(Circle().fill(Color.white))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(walkerName)
                    .font(.system(.headline, design: .rounded))
                
                Text(service)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                    Text(time)
                        .font(.system(.caption, design: .rounded).bold())
                }
                .foregroundColor(.orange)
                .padding(.top, 2)
            }
            
            Spacer()
            
            // Status Tag
            Text("Confirmed")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.green)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct BookingCardView: View {
    let title: String
    let description: String
    let actionText: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.15))
                    
                    Image(systemName: icon)
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.orange)
                }
                .frame(width: 64, height: 64)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Text(actionText)
                .font(.system(.subheadline, design: .rounded).bold())
                .foregroundColor(.orange)
                .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(33)
    }
}

#Preview {
    BookingView()
}

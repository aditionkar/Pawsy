//
//  BookingView.swift
//  Pawsy
//

import SwiftUI

struct BookingView: View {

    @ObservedObject private var store = BookingStore.shared

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
                                icon: "pawprint.fill",
                                price: "₹150"
                            )
                        }

                        NavigationLink(destination: BookingDateTimeView(serviceTitle: "Book a Sitter")) {
                            BookingCardView(
                                title: "Book a Sitter",
                                description: "In-home pet care at your place",
                                actionText: "View Availability",
                                icon: "house.fill",
                                price: "₹300"
                            )
                        }
                    }
                    .padding(.horizontal)

                    // MARK: Upcoming Bookings Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Upcoming Bookings")
                            .font(.system(.title2, design: .rounded).bold())
                            .padding(.horizontal)

                        // Hardcoded existing booking
                        UpcomingBookingCard(
                            walkerName: "Riya Sengupta",
                            time: "Today, 6:00 PM",
                            service: "Dog Walking",
                            status: .confirmed
                        )
                        .padding(.horizontal)

                        // Dynamically added bookings from store
                        ForEach(store.upcoming) { booking in
                            UpcomingBookingCard(
                                walkerName: booking.walkerName,
                                time: "\(booking.date), \(booking.time.formatted(.dateTime.hour().minute()))",
                                service: booking.serviceTitle.replacingOccurrences(of: "Book a ", with: ""),
                                status: booking.status
                            )
                            .padding(.horizontal)
                        }
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
    let status: BookingStatus

    private var statusColor: Color {
        switch status {
        case .pending:   return .orange
        case .confirmed: return .green
        case .completed: return .blue
        case .cancelled: return .red
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
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

            Text(status.rawValue)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(statusColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(statusColor.opacity(0.1))
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
    let price: String

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

                HStack(spacing: 6) {
                    Text(price)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("/hr")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.secondary)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary.opacity(0.5))
                }
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

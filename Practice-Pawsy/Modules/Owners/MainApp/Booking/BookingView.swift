//
//  BookingView.swift
//  Pawsy
//

import SwiftUI
import MapKit

// MARK: - Walker Location (Identifiable wrapper)
struct WalkerLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

// MARK: - Tracking Sheet
struct TrackingSheetView: View {
    let walkerName: String
    let petName: String

    @State private var walkerLocation = WalkerLocation(
        coordinate: CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    )
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707),
        span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
    )
    @State private var distanceKm: Double = 0.0
    @State private var elapsedMin: Int = 0
    @State private var etaMin: Int = 20

    // Simulated path around Chennai
    private let simulatedPath: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707),
        CLLocationCoordinate2D(latitude: 13.0840, longitude: 80.2715),
        CLLocationCoordinate2D(latitude: 13.0855, longitude: 80.2700),
        CLLocationCoordinate2D(latitude: 13.0862, longitude: 80.2680),
        CLLocationCoordinate2D(latitude: 13.0850, longitude: 80.2660),
        CLLocationCoordinate2D(latitude: 13.0835, longitude: 80.2670),
        CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707)
    ]
    @State private var pathIndex = 0
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 0) {

            // Handle
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 12)
                .padding(.bottom, 8)

            // Header
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tracking \(petName)")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 7, height: 7)
                        Text("Live · with \(walkerName)")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 15)
            .padding(.leading, 20)
            .padding(.top, 20)

            // Map
            Map(coordinateRegion: $region, annotationItems: [walkerLocation]) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(Color.orange.opacity(0.25))
                                .frame(width: 36, height: 36)
                            Image(systemName: "pawprint.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                        }
                        Text(walkerName.components(separatedBy: " ").first ?? walkerName)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemBackground))
                            .cornerRadius(6)
                    }
                }
            }
            .frame(height: 300)
            .cornerRadius(20)
            .padding(.horizontal)

            // Stats row
            HStack(spacing: 10) {
                TrackingStatBox(label: "Distance", value: String(format: "%.1f km", distanceKm))
                TrackingStatBox(label: "Duration", value: "\(elapsedMin) min")
                TrackingStatBox(label: "ETA home", value: "~\(etaMin) min")
            }
            .padding()

            Spacer()
        }
        .onAppear { startSimulation() }
        .onDisappear { timer?.invalidate() }
    }

    private func startSimulation() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            guard pathIndex < simulatedPath.count else {
                timer?.invalidate()
                return
            }
            let next = simulatedPath[pathIndex]
            withAnimation(.easeInOut(duration: 2)) {
                walkerLocation = WalkerLocation(coordinate: next)
                region.center = next
            }
            pathIndex += 1
            distanceKm += 0.15
            elapsedMin += 1
            etaMin = max(0, etaMin - 1)
        }
    }
}

// MARK: - Stat Box
struct TrackingStatBox: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(.subheadline, design: .rounded).bold())
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(14)
    }
}

// MARK: - BookingView
struct BookingView: View {

    @ObservedObject private var store = BookingStore.shared
    @State private var showTracker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {

                    // MARK: Booking Options
                    VStack(spacing: 20) {
                        NavigationLink(destination: BookingDateTimeView(serviceTitle: "Book a Walk")) {
                            BookingCardView(
                                title: "Book a Walk",
                                description: "Guided outing",
                                actionText: "Start Schedule",
                                icon: "pawprint.fill",
                                price: "₹150"
                            )
                        }

                        NavigationLink(destination: BookingDateTimeView(serviceTitle: "Book a Sitter")) {
                            BookingCardView(
                                title: "Book a Sitter",
                                description: "In-home pet care",
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

                        // Hardcoded ongoing — long press to track
                        UpcomingBookingCard(
                            walkerName: "Raaghav Sinha",
                            time: "Today, 6:00 PM",
                            service: "Dog Walking",
                            status: .ongoing
                        )
                        .padding(.horizontal)
                        .onLongPressGesture {
                            showTracker = true
                        }
                        .sheet(isPresented: $showTracker) {
                            TrackingSheetView(walkerName: "Raaghav Sinha", petName: "Buddy")
                                .presentationDetents([.medium, .large])
                                .presentationDragIndicator(.hidden)
                                .presentationBackground(Color(.systemGroupedBackground))
                        }

                        UpcomingBookingCard(
                            walkerName: "Riya Sengupta",
                            time: "Tomorrow, 8:00 PM",
                            service: "Dog Walking",
                            status: .confirmed
                        )
                        .padding(.horizontal)

                        // Dynamic bookings
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

// MARK: - Subviews (unchanged)

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
        case .ongoing:   return .brown
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
        .cornerRadius(33)
    }
}

struct BookingCardView: View {
    let title: String
    let description: String
    let actionText: String
    let icon: String
    let price: String

    var body: some View {
        HStack(spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.15))
                    Image(systemName: icon)
                        .font(.system(.title2, design: .rounded))
                        .foregroundColor(.orange)
                }
                .frame(width: 55, height: 55)

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
                .padding(.leading, 6)
                .padding(.top, 3)

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
                .padding(.leading, 40)
                .padding(.top, 3)
            }
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

//
//  BookingStore.swift
//  Practice-Pawsy
//
//  Created by user@37 on 04/04/26.
//

import Foundation
import Combine

// MARK: - Booking Model

struct Booking: Codable, Identifiable {
    let id: UUID
    let serviceTitle: String
    let date: String           // display string, e.g. "Thu, 24 Apr"
    let time: Date
    let duration: String
    let walkerName: String
    var status: BookingStatus

    init(
        id: UUID = UUID(),
        serviceTitle: String,
        date: String,
        time: Date,
        duration: String,
        walkerName: String,
        status: BookingStatus = .pending
    ) {
        self.id = id
        self.serviceTitle = serviceTitle
        self.date = date
        self.time = time
        self.duration = duration
        self.walkerName = walkerName
        self.status = status
    }
}

enum BookingStatus: String, Codable {
    case pending   = "Pending"
    case confirmed = "Confirmed"
    case completed = "Completed"
    case cancelled = "Cancelled"
}

// MARK: - BookingStore

final class BookingStore: ObservableObject {
    static let shared = BookingStore()

    @Published private(set) var bookings: [Booking] = []

    private let key = "pawsy_bookings"

    private init() {
        load()
    }

    // MARK: Public API

    func add(_ booking: Booking) {
        bookings.append(booking)
        save()
    }

    func updateStatus(id: UUID, status: BookingStatus) {
        guard let idx = bookings.firstIndex(where: { $0.id == id }) else { return }
        bookings[idx].status = status
        save()
    }

    func delete(id: UUID) {
        bookings.removeAll { $0.id == id }
        save()
    }

    // MARK: Convenience

    /// All bookings whose walk/sit time is in the future, sorted soonest first.
    var upcoming: [Booking] {
        bookings
            .filter { $0.time > Date() }
            .sorted { $0.time < $1.time }
    }

    // MARK: Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(bookings) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([Booking].self, from: data)
        else { return }
        bookings = decoded
    }
}

//
//  ChooseWalkersSittersView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct Walker: Identifiable {
    let id = UUID()
    let name: String
    let rating: Double
    let totalWalks: Int
    let bio: String
    let image: String
    let isPro: Bool
    let isBestMatch: Bool
}

struct ChooseWalkersSittersView: View {
    let serviceTitle: String
    let selectedDate: String
    let selectedTime: Date
    let selectedDuration: String
    
    let walkers = [
        Walker(name: "Julianna Reed", rating: 4.9, totalWalks: 128, bio: "Expert in high-energy breeds and trail walking. 5 years experience.", image: "person.circle.fill", isPro: false, isBestMatch: true),
        Walker(name: "Marcus Thorne", rating: 4.8, totalWalks: 94, bio: "Calm and patient with senior dogs.", image: "person.circle.fill", isPro: false, isBestMatch: false),
        Walker(name: "Elena Vance", rating: 5.0, totalWalks: 210, bio: "Certified trainer and pet enthusiast.", image: "person.circle.fill", isPro: true, isBestMatch: false),
        Walker(name: "Leo Kim", rating: 4.7, totalWalks: 56, bio: "Active walker who loves big dogs.", image: "person.circle.fill", isPro: false, isBestMatch: false)
    ]
    
    @State private var selectedWalkerID: UUID?

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Background
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Summary Bar (Now inside ScrollView)
                    HStack {
                        Label("Today, \(selectedTime.formatted(.dateTime.hour().minute())) · \(selectedDuration)", systemImage: "calendar")
                            .font(.system(.subheadline, design: .rounded).bold())
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)
                    
                    // MARK: List of Walkers
                    VStack(spacing: 16) {
                        ForEach(walkers) { walker in
                            WalkerCard(walker: walker, isSelected: selectedWalkerID == walker.id) {
                                selectedWalkerID = walker.id
                            }
                        }
                    }
                    
                    // Extra padding at the bottom so content doesn't get hidden by the fixed button
                    Spacer(minLength: 100)
                }
                .padding()
            }

            // MARK: Confirm Button (Fixed at Bottom)
                        VStack(spacing: 0) {
                            Divider()
                            
                            // NavigationLink styled as a Button
                            NavigationLink(destination: BookingConfirmationView(
                                serviceTitle: serviceTitle,
                                selectedDate: selectedDate,
                                selectedTime: selectedTime,
                                selectedDuration: selectedDuration,
                                walkerName: walkers.first(where: { $0.id == selectedWalkerID })?.name ?? "Walker"
                            )) {
                                HStack {
                                    Text("Confirm Booking")
                                    Image(systemName: "arrow.right")
                                }
                                .font(.system(.headline, design: .rounded).bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(selectedWalkerID == nil ? Color.gray : Color.orange)
                                .clipShape(Capsule())
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 10)
                            }
                            .disabled(selectedWalkerID == nil) // Button stays gray and unclickable until a walker is picked
                            .background(BlurView(style: .systemChromeMaterial))
                        }
        }
        .navigationTitle(serviceTitle.contains("Walk") ? "Choose Walkers" : "Choose Sitters")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Subviews

struct WalkerCard: View {
    let walker: Walker
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                // Profile Image
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: walker.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .foregroundColor(.gray.opacity(0.3))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(walker.name)
                            .font(.system(.headline, design: .rounded))
                        
                        Spacer()
                        
                        Button(action: onSelect) {
                            Text(isSelected ? "Selected" : "Select")
                                .font(.system(.subheadline, design: .rounded).bold())
                                .foregroundColor(isSelected ? .white : .orange)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(isSelected ? Color.orange : Color.white)
                                .overlay(
                                    Capsule().stroke(Color.orange, lineWidth: 1)
                                )
                                .clipShape(Capsule())
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", walker.rating))
                            .bold()
                        Text("· \(walker.totalWalks) walks done")
                            .foregroundColor(.secondary)
                    }
                    .font(.system(.caption, design: .rounded))
                }
            }
            
            Text(walker.bio)
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
        )
    }
}

// Helper for the blurred background effect behind the button
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    NavigationStack {
        ChooseWalkersSittersView(serviceTitle: "Book a Walk", selectedDate: "24", selectedTime: Date(), selectedDuration: "30 min")
    }
}

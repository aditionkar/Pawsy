//
//  BookingConfirmationView.swift
//  Pawsy
//
//  Created by user@37 on 02/04/26.
//

import SwiftUI

struct BookingConfirmationView: View {
    let serviceTitle: String
    let selectedDate: String
    let selectedTime: Date
    let selectedDuration: String
    let walkerName: String
    
    // Environment to handle dismissing the view
    @Environment(\.dismiss) var dismiss
    
    @State private var checkmarkValue: CGFloat = 0
    @State private var scaleValue: CGFloat = 0.5
    @State private var opacityValue: Double = 0
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // MARK: Animated Checkmark Header
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(scaleValue)
                
                Circle()
                    .fill(Color.orange.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .scaleEffect(scaleValue * 1.1)

                Circle()
                    .fill(Color.orange)
                    .frame(width: 100, height: 100)
                
                CheckmarkShape()
                    .trim(from: 0, to: checkmarkValue)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                    .frame(width: 40, height: 40)
            }
            .opacity(opacityValue)
            
            // MARK: Text Content
            VStack(spacing: 16) {
                Text("\(serviceTitle.replacingOccurrences(of: "Book a ", with: "")) Booked!")
                    .font(.system(.largeTitle, design: .rounded).bold())
                    .foregroundColor(Color(red: 0.75, green: 0.4, blue: 0.2))

                // DYNAMIC DATE FIX: Using selectedDate variable
                Text("Luna is all set for her outdoor adventure\non ")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                + Text(selectedDate) // Changed from hardcoded string
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundColor(Color(red: 0.75, green: 0.4, blue: 0.2))
                + Text(" at \(selectedTime.formatted(.dateTime.hour().minute()))")
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundColor(Color(red: 0.75, green: 0.4, blue: 0.2))
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            
            // MARK: Walker Small Card
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("PRO")
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .offset(x: 4, y: 4)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(walkerName)
                        .font(.system(.headline, design: .rounded))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text("4.9")
                            .font(.system(.caption, design: .rounded).bold())
                        Text("(\(Int.random(in: 50...150)) walks)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(24)
            .padding(.horizontal)
            
            Spacer()
            
            // MARK: Action Buttons
            VStack(spacing: 12) {
                Button(action: {}) {
                    Text("View Details")
                        .font(.system(.headline, design: .rounded).bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.orange)
                        .clipShape(Capsule())
                }
                
                Button(action: {
                    // Logic to return home (Dismissing current navigation stack)
                    dismiss()
                }) {
                    Text("Back to Home")
                        .font(.system(.headline, design: .rounded).bold())
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.orange.opacity(0.05))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.orange.opacity(0.1), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
        // Show the navigation bar so the back button is visible
        .navigationBarHidden(false)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)) {
                scaleValue = 1.0
                opacityValue = 1.0
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                checkmarkValue = 1.0
            }
        }
    }
}

// MARK: - Helper Checkmark Shape
struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - rect.width/6, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}

#Preview {
    BookingConfirmationView(
        serviceTitle: "Book a Walk",
        selectedDate: "24",
        selectedTime: Date(),
        selectedDuration: "30 min",
        walkerName: "Marcus Thompson"
    )
}

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
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Description Header
                    Text("Select the best care experience for your pet's modern lifestyle.")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
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
                    
                    Spacer(minLength: 40)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Book a Service")
            .navigationBarTitleDisplayMode(.large)
        }
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
        .cornerRadius(24)
    }
}

#Preview {
    BookingView()
}

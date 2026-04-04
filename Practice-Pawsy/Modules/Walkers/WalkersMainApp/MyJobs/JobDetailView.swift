//
//  JobDetailView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI
import MapKit

struct JobDetailView: View {
    let job: JobRecord
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: - Pet Detail Card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(spacing: 15) {
                            Image(systemName: job.petImageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .background(Color(.systemGray6))
                                .cornerRadius(20)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(job.petName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("\(job.breed) • 2 Years")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Text(job.weight)
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(33)

                    // MARK: - Payout & Info Grid
                    HStack(spacing: 15) {
                        VStack(alignment: .leading) {
                            Text("Total Payout")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                            
                            Text(job.payout)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Incl. \(job.tip) tip")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                        .padding(.leading, 8)
                        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
                        .background(job.statusColor == .gray ? Color.gray : Color.orange)
                        .cornerRadius(33)
                        
                        VStack(spacing: 12) {
                            InfoSmallCard(title: "Service", value: job.duration, icon: "pawprint.fill", color: job.statusColor.opacity(0.3))
                            InfoSmallCard(title: "Date", value: job.date, icon: nil, color: Color(.systemGray5))
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // MARK: - Time & Address Section
                    VStack(alignment: .leading, spacing: 20) {
                        DetailRow(icon: "clock.fill", label: "Preferred Time", value: job.time)

                        Button(action: { openInMaps() }) {
                            VStack(alignment: .leading, spacing: 10) {
                                DetailRow(icon: "mappin.circle.fill", label: "Address", value: job.address)
                                
                                if job.statusColor != .gray {
                                    Text("Open maps to get the directions of the owner's house")
                                        .font(.caption)
                                        .foregroundColor(.brown)
                                        .fontWeight(.semibold)
                                }
                                
                                // MARK: - Updated Map Image Scaling
                                Image(systemName: "map.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(20)
                                    .frame(height: 120)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.secondary.opacity(0.3))
                                    .background(Color(.systemGray6))
                                    .cornerRadius(20)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(20)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(33)
                    
                    // Only add extra spacing if the Done button is visible
                    if job.statusColor != .gray {
                        Spacer(minLength: 100)
                    }
                }
                .padding()
            }
            
            // MARK: - Sticky Done Button (Hidden for Past Jobs)
            if job.statusColor != .gray {
                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.orange)
                        .cornerRadius(33)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle("Job Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    func openInMaps() {
        let encodedAddress = job.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?address=\(encodedAddress)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Helper Views
struct InfoSmallCard: View {
    let title: String
    let value: String
    let icon: String?
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary)
            Spacer()
            HStack {
                if let icon = icon {
                    Image(systemName: icon).foregroundColor(.brown)
                }
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .padding(.leading, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(33)
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.brown)
                .frame(width: 40, height: 40)
                .background(Color.brown.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    NavigationStack {
        JobDetailView(job: JobRecord(
            petName: "Cooper",
            ownerName: "Sarah Jenkins",
            service: "AFTERNOON WALK",
            date: "Today",
            time: "02:30 PM",
            duration: "60m Walk",
            address: "BJ-91, Salt Lake, Kolkata",
            petImageName: "dog.fill",
            statusColor: .orange,
            breed: "Golden Retriever",
            weight: "28 kg",
            payout: "$42.00",
            tip: "$5.00"
        ))
    }
}

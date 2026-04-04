//
//  MyJobsView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

// MARK: - Data Model
struct JobRecord: Identifiable {
    let id = UUID()
    let petName: String
    let ownerName: String
    let service: String
    let date: String
    let time: String
    let duration: String
    let address: String
    let petImageName: String
    let statusColor: Color
    // New Fields
    let breed: String
    let weight: String
    let payout: String
    let tip: String
}

struct MyJobsView: View {
    @State private var selectedTab = "Confirmed"
    let tabs = ["Confirmed", "Past Jobs"]
    
    // Updated Sample Data with all necessary JobRecord fields
    let confirmedJobs = [
        JobRecord(
            petName: "Cooper",
            ownerName: "Sarah Jenkins",
            service: "AFTERNOON WALK",
            date: "Today",
            time: "5:00 PM",
            duration: "45 min",
            address: "DC Block, Sector 1, Bidhannagar, Kolkata",
            petImageName: "dog.fill",
            statusColor: .orange,
            breed: "Golden Retriever",
            weight: "28 kg",
            payout: "$42.00",
            tip: "$5.00"
        ),
        JobRecord(
            petName: "Luna",
            ownerName: "Michael Chen",
            service: "FEEDING",
            date: "Tomorrow",
            time: "8:00 AM",
            duration: "30 min",
            address: "Plot No. 140 & 151, GST Road, Vallancherry Village, Guduvanchery, Chennai",
            petImageName: "cat.fill",
            statusColor: .orange,
            breed: "Siamese Cat",
            weight: "4.5 kg",
            payout: "$25.00",
            tip: "$3.00"
        )
    ]

    let pastJobs = [
        JobRecord(
            petName: "Milo",
            ownerName: "Emma Watson",
            service: "CAT SITTING",
            date: "Oct 24, 2023",
            time: "2:00 PM",
            duration: "2 hours",
            address: "Plot No. 140 & 151, GST Road, Vallancherry Village, Guduvanchery, Chennai",
            petImageName: "pawprint.fill",
            statusColor: .gray,
            breed: "Indie Cat",
            weight: "5 kg",
            payout: "$60.00",
            tip: "$10.00"
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Custom Picker
                        Picker("Job Status", selection: $selectedTab) {
                            ForEach(tabs, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        
//                        Text(selectedTab == "Confirmed" ? "UPCOMING SCHEDULE" : "COMPLETED JOBS")
//                            .font(.caption)
//                            .fontWeight(.bold)
//                            .foregroundColor(.secondary)
//                            .padding(.horizontal)
//                            .tracking(1.2)

                        ForEach(selectedTab == "Confirmed" ? confirmedJobs : pastJobs) { job in
                            NavigationLink(destination: JobDetailView(job: job)) {
                                JobCard(job: job)
                            }
                            .buttonStyle(PlainButtonStyle()) // Keeps card colors native
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("My Jobs")
        }
    }
}

// MARK: - Refined Card UI
struct JobCard: View {
    let job: JobRecord
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar (Date & Duration)
            HStack {
                Text("\(job.date) \(job.time)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(job.statusColor)
                
                Spacer()
                
                Text(job.duration)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(job.statusColor.opacity(0.1))
            
            // Main Content
            HStack(spacing: 15) {
                // Pet Image
                Image(systemName: job.petImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.petName)
                        .font(.headline)
                    
                    Text("Owner: \(job.ownerName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(20)
            
            Divider().padding(.horizontal, 20)
            
            // Address Footer
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(job.statusColor)
                Text(job.address)
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.7))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(33)
        .padding(.horizontal)
    }
}

#Preview {
    MyJobsView()
}

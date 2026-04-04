//
//  RequestsView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct PetRequest: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let breed: String
    let tag: String
    let date: String
    let time: String
    let duration: String
    let distance: String
    let avatarColor: Color
}

struct RequestsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var requests = [
        PetRequest(imageName: "dog2", name: "Cooper", breed: "Golden Retriever", tag: "WALK", date: "Oct 24, 2023", time: "02:30 PM", duration: "45 Mins", distance: "1.2 Miles", avatarColor: .orange.opacity(0.2)),
        PetRequest(imageName: "dog3", name: "Luna", breed: "Siamese Cat", tag: "SIT", date: "Oct 26, 2023", time: "09:00 AM", duration: "2 Hours", distance: "0.8 Miles", avatarColor: .blue.opacity(0.1)),
        PetRequest(imageName: "dog4", name: "Bruno", breed: "Beagle", tag: "WALK", date: "Oct 28, 2023", time: "11:00 AM", duration: "1 Hour", distance: "2.5 Miles", avatarColor: .green.opacity(0.1))
    ]
    
    // Alert States
    @State private var showingAlert = false
    @State private var selectedRequest: PetRequest?
    @State private var alertTitle = ""
    
    // Logout Alert State
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(requests) { request in
                            RequestCardView(request: request) { actionType in
                                // Trigger Alert
                                self.alertTitle = actionType == .accept ? "Accept Request?" : "Decline Request?"
                                self.selectedRequest = request
                                self.showingAlert = true
                            }
                            .transition(.opacity.combined(with: .scale))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Requests")
            .navigationBarTitleDisplayMode(.large)
            
            // Request Action Alert
            .alert(alertTitle, isPresented: $showingAlert, presenting: selectedRequest) { request in
                Button("Cancel", role: .cancel) { }
                Button(alertTitle.contains("Accept") ? "Accept" : "Decline", role: .destructive) {
                    removeRequest(request)
                }
            } message: { request in
                Text("Are you sure you want to proceed with \(request.name)?")
            }
            
            // Logout Confirmation Alert
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            showingLogoutAlert = true
                        } label: {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }

    private func removeRequest(_ request: PetRequest) {
        withAnimation(.spring()) {
            requests.removeAll { $0.id == request.id }
        }
    }
}

// Enum to distinguish which button was pressed
enum ActionType {
    case accept, decline
}

struct RequestCardView: View {
    let request: PetRequest
    var onAction: (ActionType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                // FETCHING ASSET IMAGES HERE
                Image(request.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .background(request.avatarColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading) {
                    Text(request.name)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(request.breed)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(request.tag)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(request.tag == "SIT" ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                    .foregroundColor(request.tag == "SIT" ? .blue : .green)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            VStack(spacing: 15) {
                HStack {
                    InfoItem(label: "Date", value: request.date)
                    Spacer()
                    InfoItem(label: "Time", value: request.time)
                }
                HStack {
                    InfoItem(label: "Duration", value: request.duration)
                    Spacer()
                    InfoItem(label: "Distance", value: request.distance)
                }
            }
            
            HStack(spacing: 15) {
                Button(action: { onAction(.decline) }) {
                    Text("Decline")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color(.systemGray5))
                        .cornerRadius(33)
                }
                
                Button(action: { onAction(.accept) }) {
                    Text("Accept")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.orange)
                        .cornerRadius(33)
                }
            }
        }
        .padding(25)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(33)
    }
}

struct InfoItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .frame(minWidth: 100, alignment: .leading)
    }
}

#Preview {
    RequestsView()
        .environmentObject(AuthViewModel())
}

//
//  WalkerOrSitterView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkerOrSitterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedOption: String? = "Pet Walker" // Default selection
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        Text("How do you want to help?")
                            .font(.system(size: 34, weight: .bold))
                            .padding(.top, 20)
                            .padding(.horizontal)
                        
                        VStack(spacing: 20) {
                            SelectionCard(
                                title: "Pet Walker",
                                subtitle: "Take dogs out for scheduled walks.",
                                icon: "figure.walk",
                                isSelected: selectedOption == "Pet Walker"
                            ) {
                                selectedOption = "Pet Walker"
                            }
                            
                            SelectionCard(
                                title: "Pet Sitter",
                                subtitle: "Stay with pets at their home for the day.",
                                icon: "house.fill",
                                isSelected: selectedOption == "Pet Sitter"
                            ) {
                                selectedOption = "Pet Sitter"
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 120)
                    }
                }
                
                // MARK: - Navigation Button
                Button(action: { /* Action to next screen */ }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(selectedOption == nil ? Color.gray.opacity(0.5) : Color.orange)
                        .cornerRadius(33)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                .disabled(selectedOption == nil)
            }
        }
    }
}

// MARK: - Custom Selection Card Component

struct SelectionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    // Icon Container
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.orange)
                        .frame(width: 50, height: 50)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                    
                    Spacer()
                    
                    // Custom Radio Button
                    ZStack {
                        Circle()
                            .stroke(isSelected ? Color.orange : Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 14, height: 14)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(25)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(33)
            .overlay(
                RoundedRectangle(cornerRadius: 33)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(), value: isSelected)
    }
}

#Preview {
    WalkerOrSitterView()
}

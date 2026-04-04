//
//  WalkerOrSitterView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkerOrSitterView: View {
    @Binding var selectedOption: String?
    let onNext: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                Text("How do you want to help?")
                    .font(.system(size: 28, weight: .bold))
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
            }
            .padding(.bottom, 40)
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(Color(.systemOrange))
                    .clipShape(Capsule())
            }
            .disabled(selectedOption == nil)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGroupedBackground).opacity(0), Color(.systemGroupedBackground)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
            )
        }
    }
}

// MARK: - Supporting Components (Keep as is)
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
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.orange)
                        .frame(width: 50, height: 50)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                    
                    Spacer()
                    
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
    }
}


//#Preview {
//    WalkerOrSitterView()
//}

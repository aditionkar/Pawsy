//
//  DetailsView.swift
//  Practice-Pawsy
//
//  Created by admin20 on 04/04/26.
//

import SwiftUI

struct DetailsView: View {
    let symptoms: [String]
    @Binding var path: NavigationPath
    
    // Set to nil so nothing is picked initially
    @State private var duration: String? = nil
    @State private var appetite: String? = nil
    @State private var energy: String? = nil
    
    let durations = ["1 day", "2 days", "3 days"]
    let options = ["low", "normal"]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) { // Increased spacing for better UI
                
                Text("A few quick questions")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.top)
                
                // Duration Selection
                selectionSection(title: "How long has this been happening?",
                                 items: durations,
                                 selection: $duration)
                
                // Appetite Selection
                selectionSection(title: "Appetite level",
                                 items: options,
                                 selection: $appetite)
                
                // Energy Selection
                selectionSection(title: "Energy level",
                                 items: options,
                                 selection: $energy)
                
                Spacer()
                
                // Analyze Button
                Button(action: {
                    if let dur = duration, let app = appetite, let nrg = energy {
                        path.append(SOSRoute.loading(
                            symptoms: symptoms,
                            duration: dur,
                            appetite: app,
                            energy: nrg
                        ))
                    }
                }) {
                    Text("Analyze")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? Color.orange : Color.gray.opacity(0.5))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(!isFormValid) // Disable if nothing is selected
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    // Helper to check if all fields are selected
    private var isFormValid: Bool {
        duration != nil && appetite != nil && energy != nil
    }
    
    // Helper View for the sections
    @ViewBuilder
    private func selectionSection(title: String, items: [String], selection: Binding<String?>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(items, id: \.self) { item in
                    CustomOptionButton(
                        title: item.capitalized,
                        isSelected: selection.wrappedValue == item,
                        action: { selection.wrappedValue = item }
                    )
                }
            }
        }
    }
}

struct CustomOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(isSelected ? .orange : .primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.orange.opacity(0.1) : Color(.systemBackground))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 1)
                )
        }
    }
}

#Preview {
    DetailsView(
        symptoms: ["vomiting", "lethargy"],
        path: .constant(NavigationPath())
    )
}

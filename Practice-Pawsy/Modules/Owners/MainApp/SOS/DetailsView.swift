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
    
    @State private var duration = "1 day"
    @State private var appetite = "normal"
    @State private var energy = "normal"
    
    let durations = ["1 day", "2 days", "3 days"]
    let options = ["low", "normal"]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                Text("A few quick questions")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.top)
                
                // Duration
                VStack(alignment: .leading, spacing: 8) {
                    Text("How long has this been happening?")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Picker("Duration", selection: $duration) {
                        ForEach(durations, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Appetite
                VStack(alignment: .leading, spacing: 8) {
                    Text("Appetite level")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Picker("Appetite", selection: $appetite) {
                        ForEach(options, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Energy
                VStack(alignment: .leading, spacing: 8) {
                    Text("Energy level")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Picker("Energy", selection: $energy) {
                        ForEach(options, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Spacer()
                
                // Analyze Button
                Button(action: {
                    // Navigate to loading screen with all data
                    path.append(SOSRoute.loading(
                        symptoms: symptoms,
                        duration: duration,
                        appetite: appetite,
                        energy: energy
                    ))
                }) {
                    Text("Analyze")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemOrange))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailsView(
        symptoms: ["vomiting", "lethargy"],
        path: .constant(NavigationPath())
    )
}

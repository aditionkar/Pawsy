//
//  WalkersDetailsView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkersDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - State Variables
    @State private var fullName: String = ""
    @State private var phone: String = ""
    @State private var city: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // MARK: - Profile Image Picker UI
                        ZStack(alignment: .bottomTrailing) {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.orange.opacity(0.1))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.orange)
                                )
                            
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 10, y: 10)
                        }
                        .padding(.top, 40)
                        
                        // MARK: - Identity Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("IDENTITY")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 0) {
                                CustomInputField(icon: "person.fill", placeholder: "Full name", text: $fullName)
                                Divider().padding(.leading, 50)
                                CustomInputField(icon: "phone.fill", placeholder: "Phone", text: $phone)
                            }
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(25)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Location Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("LOCATION")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            CustomInputField(icon: "mappin.circle.fill", placeholder: "City", text: $city)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(25)
                            
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "info.circle.fill")
                                    .font(.caption)
                                Text("We'll show you nearby requests.")
                                    .font(.caption)
                            }
                            .foregroundColor(.secondary)
                            .padding(.leading, 10)
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 120)
                    }
                }
                
                // MARK: - Continue Button
                Button(action: { /* Navigate or Save logic */ }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.orange)
                        .cornerRadius(33)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .navigationTitle("Your Details")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Custom Components

struct CustomInputField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 24)
            
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.6)))
                .font(.body)
        }
        .padding()
        .frame(height: 60)
    }
}

#Preview {
    WalkersDetailsView()
}

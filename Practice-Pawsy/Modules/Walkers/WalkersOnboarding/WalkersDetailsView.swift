//
//  WalkersDetailsView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI
import PhotosUI

struct WalkersDetailsView: View {
    @Binding var fullName: String
    @Binding var phone: String
    @Binding var city: String
    let onNext: () -> Void
    
    // Profile image states
    @State private var selectedImage: UIImage?
    @State private var showSheet = false
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Basic details")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 64)
            
            // MARK: - Profile Image Picker UI
            Button(action: { showSheet = true }) {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.orange.opacity(0.1))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Group {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                } else {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.orange)
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    
                    Circle()
                        .fill(Color(.systemOrange))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 10, y: 10)
                }
            }
            .padding(.top, 40)
            
            // MARK: - Text Fields
            VStack(spacing: 20) {
                TextField("Full Name", text: $fullName)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                
                TextField("Phone Number", text: $phone)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .keyboardType(.phonePad)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                
                TextField("City", text: $city)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 28)
            .padding(.top, 40)
            
            // MARK: - Info Text
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("We'll show you nearby requests.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 16)
            
            Spacer()
            
            // MARK: - Continue Button
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(Color(.systemOrange))
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        
        // MARK: - Modal Sheet
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 0) {
                // Handle
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray4))
                    .frame(width: 36, height: 5)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                
                Text("Add profile picture")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .padding(.bottom, 24)
                
                VStack(spacing: 0) {
                    Button(action: {
                        showSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showCamera = true
                        }
                    }) {
                        HStack {
                            Text("Take photo")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "camera")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                    }
                    
                    Divider()
                        .padding(.leading, 20)
                    
                    Button(action: {
                        showSheet = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showPhotoPicker = true
                        }
                    }) {
                        HStack {
                            Text("Choose photo")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "photo")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .presentationDetents([.height(260)])
            .presentationDragIndicator(.hidden)
        }
        
        // MARK: - Camera
        .fullScreenCover(isPresented: $showCamera) {
            CameraPickerView(image: $selectedImage)
                .ignoresSafeArea()
        }
        
        // MARK: - Photo Library
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem, matching: .images)
        .onChange(of: photoPickerItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

#Preview {
    WalkersDetailsView(
        fullName: .constant(""),
        phone: .constant(""),
        city: .constant(""),
        onNext: {}
    )
}

//
//  PetProfileView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 04/04/26.
//


import SwiftUI

struct PetProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Pet data
    @State private var petName = "Buddy"
    @State private var petBreed = "Golden Retriever"
    @State private var petAge = "2 years"
    @State private var petWeight = "32 kg"
    @State private var petGender = "Male"
    
    @State private var showingImagePicker = false
    @State private var profileImage: UIImage?
    @State private var showingEditSheet = false
    @State private var editPetName = ""
    @State private var editPetBreed = ""
    @State private var editPetAge = ""
    @State private var editPetWeight = ""
    @State private var editPetGender = ""
    
    var body: some View {
        List {
            // MARK: - Profile Picture Section
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        // Profile Image
                        ZStack(alignment: .bottomTrailing) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.systemOrange), lineWidth: 3)
                                    )
                            } else if let savedImage = loadImage() {
                                Image(uiImage: savedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.systemOrange), lineWidth: 3)
                                    )
                            } else {
                                Image("dog1") // 👈 your asset image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color(.systemOrange), lineWidth: 3)
                                    )
                            }
                            
                            // Edit Button
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(.systemOrange))
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                }
                            }
                            .offset(x: -5, y: -5)
                        }
                        
                        // Pet Name
                        Text(petName)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(petBreed)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
                .listRowBackground(Color(.systemGroupedBackground))
            }
            
            // MARK: - Pet Information Section
            Section {
                SettingsRow(
                    icon: "pawprint.fill",
                    iconColor: .orange,
                    title: "Name",
                    value: petName
                )
                
                SettingsRow(
                    icon: "dog.fill",
                    iconColor: .orange,
                    title: "Breed",
                    value: petBreed
                )
                
                SettingsRow(
                    icon: "birthday.cake.fill",
                    iconColor: .orange,
                    title: "Age",
                    value: petAge
                )
                
                SettingsRow(
                    icon: "scalemass.fill",
                    iconColor: .orange,
                    title: "Weight",
                    value: petWeight
                )
                
                SettingsRow(
                    icon: "figure.stand",
                    iconColor: .orange,
                    title: "Gender",
                    value: petGender
                )
            } header: {
                Text("Pet Information")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Pet Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Only Edit button - no back button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Load current values into edit state
                    editPetName = petName
                    editPetBreed = petBreed
                    editPetAge = petAge
                    editPetWeight = petWeight
                    editPetGender = petGender
                    showingEditSheet = true
                }) {
                    Text("Edit")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(.systemOrange))
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $profileImage)
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                Form {
                    Section {
                        TextField("Name", text: $editPetName)
                            .font(.system(size: 17, design: .rounded))
                        
                        TextField("Breed", text: $editPetBreed)
                            .font(.system(size: 17, design: .rounded))
                        
                        TextField("Age", text: $editPetAge)
                            .font(.system(size: 17, design: .rounded))
                        
                        TextField("Weight", text: $editPetWeight)
                            .font(.system(size: 17, design: .rounded))
                        
                        TextField("Gender", text: $editPetGender)
                            .font(.system(size: 17, design: .rounded))
                    } header: {
                        Text("Edit Pet Information")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                }
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showingEditSheet = false
                        }
                        .foregroundColor(Color(.systemOrange))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            // Save changes
                            petName = editPetName
                            petBreed = editPetBreed
                            petAge = editPetAge
                            petWeight = editPetWeight
                            petGender = editPetGender
                            showingEditSheet = false
                            savePetProfile()
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemOrange))
                    }
                }
                .onAppear {
                    if profileImage == nil {
                        profileImage = loadImage()
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func savePetProfile() {
        // Save pet profile data to backend
        print("Pet profile saved:")
        print("Name: \(petName)")
        print("Breed: \(petBreed)")
        print("Age: \(petAge)")
        print("Weight: \(petWeight)")
        print("Gender: \(petGender)")
        // Add your save logic here
    }
    
    func loadImage() -> UIImage? {
        if let data = UserDefaults.standard.data(forKey: "petProfileImage") {
            return UIImage(data: data)
        }
        return nil
    }
}

// MARK: - Settings Row Component (Read-only display)

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            // Title
            Text(title)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
                if let data = editedImage.jpegData(compressionQuality: 0.8) {
                    UserDefaults.standard.set(data, forKey: "petProfileImage")
                }
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
                if let data = originalImage.jpegData(compressionQuality: 0.8) {
                    UserDefaults.standard.set(data, forKey: "petProfileImage")
                }
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PetProfileView()
            .environmentObject(AuthViewModel())
    }
}

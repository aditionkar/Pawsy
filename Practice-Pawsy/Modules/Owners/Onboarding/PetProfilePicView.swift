//
//  PetProfilePicView.swift
//  Pawsy
//

import SwiftUI
import PhotosUI

struct PetProfilePicView: View {
    @Binding var selectedImage: UIImage?
    let onNext: () -> Void
    let onSkip: () -> Void

    @State private var showSheet = false
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var photoPickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 0) {

            Text("Add your pet's pic")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 64)

            Spacer()

            // MARK: Profile Picture
            Button(action: { showSheet = true }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(width: 160, height: 160)

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                    } else {
                        Image(systemName: "dog.fill")
                            .font(.system(size: 56))
                            .foregroundColor(Color(.systemGray3))
                    }

                    // Plus badge
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .fill(Color(.systemOrange))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .offset(x: 8, y: 8)
                        }
                    }
                    .frame(width: 160, height: 160)
                }
            }

            Text("Select")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.top, 16)

            Spacer()

            // MARK: Buttons
            VStack(spacing: 12) {
                Button(action: onNext) {
                    Text("Next")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 16)
                        .background(Color(.systemOrange))
                        .clipShape(Capsule())
                }

                Button(action: onSkip) {
                    Text("Skip")
                        .font(.system(size: 17, weight: .regular, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .strokeBorder(Color(.systemGray4), lineWidth: 1.5)
                        )
                }
            }
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))

        // MARK: Modal Sheet
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

        // MARK: Camera
        .fullScreenCover(isPresented: $showCamera) {
            CameraPickerView(image: $selectedImage)
                .ignoresSafeArea()
        }

        // MARK: Photo Library
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

// MARK: Camera UIViewControllerRepresentable
struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPickerView
        init(_ parent: CameraPickerView) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PetProfilePicView(selectedImage: .constant(nil), onNext: {}, onSkip: {})
}

//
//  PetNameBreedView.swift
//  Pawsy
//

import SwiftUI

struct PetNameBreedView: View {
    @Binding var petName: String
    @Binding var selectedBreed: String
    let onNext: () -> Void

    let breeds = [
        "Labrador Retriever", "Golden Retriever", "German Shepherd",
        "Bulldog", "Beagle", "Poodle", "Rottweiler", "Boxer",
        "Dachshund", "Shih Tzu", "Husky", "Doberman",
        "Great Dane", "Maltese", "Pomeranian", "Mixed Breed"
    ]

    var body: some View {
        VStack(spacing: 0) {

            Text("Pet Info")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 64)

            VStack(spacing: 20) {
                TextField("Name", text: $petName)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())

                Menu {
                    ForEach(breeds, id: \.self) { breed in
                        Button(breed) { selectedBreed = breed }
                    }
                } label: {
                    HStack {
                        Text(selectedBreed.isEmpty ? "Breed" : selectedBreed)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(selectedBreed.isEmpty ? Color(.placeholderText) : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(.placeholderText))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 28)
            .padding(.top, 80)

            Spacer()

            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(Color(.systemOrange))
                    .clipShape(Capsule())
            }
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    PetNameBreedView(petName: .constant(""), selectedBreed: .constant(""), onNext: {})
}

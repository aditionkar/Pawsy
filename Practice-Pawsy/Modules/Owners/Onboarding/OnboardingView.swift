//
//  OnboardingView.swift
//  Pawsy
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    let totalSteps = 5

    @State private var ownerName = ""
    @State private var ownerPhone = ""
    @State private var petName = ""
    @State private var selectedBreed = ""
    @State private var petDOB = Date()
    @State private var petGender = ""
    @State private var petWeight: Double = 12.9
    @State private var petProfileImage: UIImage? = nil

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Progress Bar + Back Button
                if currentStep < 5 {
                    ZStack(alignment: .topLeading) {

                        HStack {
                            Spacer()
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color(.secondarySystemGroupedBackground))
                                        .frame(height: 8)

                                    Capsule()
                                        .fill(Color(.systemOrange))
                                        .frame(
                                            width: geo.size.width * CGFloat(currentStep + 1) / CGFloat(totalSteps),
                                            height: 8
                                        )
                                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                                }
                            }
                            .frame(height: 8)
                            Spacer()
                        }
                        .padding(.horizontal, 64)
                        .padding(.top, 20)

                        Button(action: { if currentStep > 0 { currentStep -= 1 } }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(.systemOrange))
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle()
                                        .fill(Color(.secondarySystemGroupedBackground))
                                )
                        }
                        .opacity(currentStep > 0 ? 1 : 0)
                        .disabled(currentStep == 0)
                        .padding(.leading, 20)
                        .padding(.top, 8)
                    }
                    .frame(height: 52)
                }

                // MARK: Step Views
                switch currentStep {
                case 0:
                    OwnerDetailsView(
                        name: $ownerName,
                        phone: $ownerPhone,
                        onNext: { withAnimation { currentStep = 1 } }
                    )
                case 1:
                    PetNameBreedView(
                        petName: $petName,
                        selectedBreed: $selectedBreed,
                        onNext: { withAnimation { currentStep = 2 } }
                    )
                case 2:
                    PetGenderAgeView(
                        dob: $petDOB,
                        selectedGender: $petGender,
                        onNext: { withAnimation { currentStep = 3 } }
                    )
                case 3:
                    PetWeightView(
                        weight: $petWeight,
                        onDone: { withAnimation { currentStep = 4 } }
                    )
                case 4:
                    PetProfilePicView(
                        selectedImage: $petProfileImage,
                        onNext: { withAnimation { currentStep = 5 } },
                        onSkip: { withAnimation { currentStep = 5 } }
                    )
                case 5:
                    PetProfileLoadView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}

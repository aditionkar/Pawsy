//
//  PetGenderAgeView.swift
//  Pawsy
//

import SwiftUI

struct PetGenderAgeView: View {
    @Binding var dob: Date
    @Binding var selectedGender: String
    let onNext: () -> Void

    @State private var showDatePicker = false

    var formattedDOB: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dob)
    }

    var body: some View {
        VStack(spacing: 0) {

            Text("Pet Info")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 64)

            VStack(spacing: 28) {

                // DOB — calendar as overlay menu
                ZStack(alignment: .top) {
                    // Gender cards always visible underneath
                    HStack(spacing: 16) {
                        Button(action: { selectedGender = "Male" }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 33)
                                    .fill(Color(.secondarySystemGroupedBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(
                                                selectedGender == "Male" ? Color.blue : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                VStack(spacing: 10) {
                                    Image("male")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 64, height: 64)
                                    Text("Male")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 140)
                        }

                        Button(action: { selectedGender = "Female" }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 33)
                                    .fill(Color(.secondarySystemGroupedBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(
                                                selectedGender == "Female" ? Color.pink : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                VStack(spacing: 10) {
                                    Image("female")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 64, height: 64)
                                    Text("Female")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 140)
                        }
                    }

                    // Calendar dropdown overlaid on top
                    if showDatePicker {
                        VStack(spacing: 0) {
                            DatePicker(
                                "",
                                selection: $dob,
                                in: ...Date(),
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)
                            .tint(Color(.systemOrange))
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.secondarySystemGroupedBackground))
                                    .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 4)
                            )
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .zIndex(1)
                    }
                }

                // DOB trigger button
                Button(action: { withAnimation(.easeInOut(duration: 0.25)) { showDatePicker.toggle() } }) {
                    HStack {
                        Text(showDatePicker || dob != Calendar.current.startOfDay(for: Date()) ? formattedDOB : "Date of Birth")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(showDatePicker ? .primary : Color(.placeholderText))
                        Spacer()
                        Image(systemName: showDatePicker ? "calendar.badge.minus" : "calendar")
                            .foregroundColor(Color(.systemOrange))
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
    PetGenderAgeView(dob: .constant(Date()), selectedGender: .constant(""), onNext: {})
}

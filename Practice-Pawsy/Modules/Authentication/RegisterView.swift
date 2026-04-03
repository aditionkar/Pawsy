//
//  RegisterView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct RoleSelectionButtonStyle: ButtonStyle {
    var isSelected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium, design: .rounded))
            // Text turns orange when selected, otherwise dark gray
            .foregroundColor(isSelected ? .orange : Color(.darkGray))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                ZStack {
                    // Light orange background when selected
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isSelected ? Color.orange.opacity(0.1) : Color(.secondarySystemGroupedBackground))
                    
                    // Orange border when selected
                    if isSelected {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.orange, lineWidth: 1.5)
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

struct RegisterView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var selectedRole: String? = nil
    @State private var isLoading = false
    @State private var localError: String? = nil

    // Post-signup navigation
    @State private var navigateToOwnerOnboarding = false
    @State private var navigateToWalkerOnboarding = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(14)

                    SecureField("Password", text: $password)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(14)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(14)

                    HStack(spacing: 12) {
                        Button(action: { selectedRole = "owner" }) {
                            Text("Pet Owner")
                        }
                        .buttonStyle(RoleSelectionButtonStyle(isSelected: selectedRole == "owner"))

                        Button(action: { selectedRole = "walker" }) {
                            Text("Pet Walker")
                        }
                        .buttonStyle(RoleSelectionButtonStyle(isSelected: selectedRole == "walker"))
                    }
                    .padding(.top, 8)
                }

                // Validation / API errors
                if let error = localError ?? authVM.authError {
                    Text(error)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Divider()

                Button(action: {
                    // Client-side validation
                    guard password == confirmPassword else {
                        localError = "Passwords do not match."
                        return
                    }
                    guard password.count >= 6 else {
                        localError = "Password must be at least 6 characters."
                        return
                    }
                    guard let role = selectedRole else { return }

                    localError = nil
                    isLoading = true

                    Task {
                        await authVM.signUp(email: email, password: password, role: role)
                        isLoading = false

                        // Only navigate if signup succeeded (no error, session exists)
                        if authVM.authError == nil && authVM.isAuthenticated {
                            if role == "owner" {
                                navigateToOwnerOnboarding = true
                            } else {
                                navigateToWalkerOnboarding = true
                            }
                        }
                    }
                }) {
                    Group {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Sign Up")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemOrange))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .opacity((selectedRole == nil || isLoading) ? 0.6 : 1.0)
                .disabled(selectedRole == nil || isLoading)

                HStack(spacing: 4) {
                    Text("Already a member?")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)

                    Button("Login") { dismiss() }
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(.systemOrange))
                }

                Spacer()
            }
            .padding(.horizontal, 28)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToOwnerOnboarding) {
            OnboardingView()
        }
        .navigationDestination(isPresented: $navigateToWalkerOnboarding) {
            WalkersOnboardingView()
        }
    }
}

#Preview {
    RegisterView(isPresented: .constant(true))
}

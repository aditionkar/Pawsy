//
//  RegisterView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//
import SwiftUI

struct RegisterView: View {
    @Binding var isPresented: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

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
                }

                Divider()

                Button(action: {}) {
                    Text("Sign Up")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemOrange))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

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
    }
}

#Preview {
    RegisterView(isPresented: .constant(true))
}

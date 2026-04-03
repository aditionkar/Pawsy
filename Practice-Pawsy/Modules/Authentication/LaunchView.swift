//
//  LaunchView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//
import SwiftUI

struct LaunchView: View {
    @State private var showLogin = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 24) {
                    PawLogoView()

                    VStack(spacing: 8) {
                        Text("Pawsy")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text("Your pet's day, sorted.")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Spacer()

                VStack(spacing: 14) {
                    Button(action: { showLogin = true }) {
                        Text("Let's Get Started")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.systemOrange))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }

                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)

                        Button("Sign in") { showLogin = true }
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(.systemOrange))
                    }
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 28)
        }
        .sheet(isPresented: $showLogin) {
            LoginView(isPresented: $showLogin)
                .presentationDetents([.height(380), .height(520)])
                .presentationCornerRadius(33)
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Paw Logo
struct PawLogoView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 33)
                .fill(Color(.systemOrange).opacity(0.12))
                .frame(width: 96, height: 96)

            Group {
                Ellipse()
                    .frame(width: 14, height: 18)
                    .offset(x: -16, y: -22)
                Ellipse()
                    .frame(width: 14, height: 18)
                    .offset(x: 16, y: -22)
                Ellipse()
                    .frame(width: 13, height: 16)
                    .offset(x: -26, y: -6)
                Ellipse()
                    .frame(width: 13, height: 16)
                    .offset(x: 26, y: -6)
                Ellipse()
                    .frame(width: 34, height: 30)
                    .offset(y: 10)
            }
            .foregroundColor(Color(.systemOrange))
        }
    }
}

#Preview {
    LaunchView()
}

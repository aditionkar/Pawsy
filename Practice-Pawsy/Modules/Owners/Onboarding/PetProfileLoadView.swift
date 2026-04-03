//
//  PetProfileLoadView.swift
//  Pawsy
//

import SwiftUI

struct PetProfileLoadView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var progress: CGFloat = 0
    @State private var isComplete = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // MARK: Paw + Ring
                ZStack {
                    Circle()
                        .stroke(Color(.secondarySystemGroupedBackground), lineWidth: 6)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color(.systemOrange),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.8), value: progress)

                    ZStack {
                        Group {
                            Ellipse().frame(width: 10, height: 13).offset(x: -12, y: -16)
                            Ellipse().frame(width: 10, height: 13).offset(x: 12, y: -16)
                            Ellipse().frame(width: 9, height: 12).offset(x: -19, y: -4)
                            Ellipse().frame(width: 9, height: 12).offset(x: 19, y: -4)
                            Ellipse().frame(width: 26, height: 22).offset(y: 8)
                        }
                        .foregroundColor(isComplete ? Color(.systemOrange) : Color(.systemOrange).opacity(0.4))
                        .animation(.easeInOut(duration: 0.4), value: isComplete)
                    }
                }

                // MARK: Text
                VStack(spacing: 8) {
                    Text(isComplete ? "All set!" : "Setting up your profile")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        .animation(.easeInOut, value: isComplete)

                    Text(isComplete ? "Welcome to Pawsy 🐾" : "Just a moment...")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .animation(.easeInOut, value: isComplete)
                }

                Spacer()

                // MARK: Continue Button
                if isComplete {
                    Button(action: {
                        authVM.isNewUser = false  // RootView switches to MainTabView
                    }) {
                        Text("Let's Go")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.systemOrange))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 48)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .onAppear {
            progress = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation { isComplete = true }
            }
        }
    }
}

#Preview {
    PetProfileLoadView()
}

//
//  WalkersOnboardingView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkersOnboardingView: View {
    // 1. Manage the current step (0 to 2)
    @State private var currentStep = 0
    @State private var isOnboardingComplete = false
    
    var body: some View {
        if isOnboardingComplete {
            // Replace this with your actual TabView file
            Text("WalkersMainTabView")
                .font(.largeTitle)
        } else {
            NavigationStack {
                ZStack(alignment: .top) {
                    Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // 2. Custom Progress Bar
                        OnboardingProgressBar(progress: Double(currentStep + 1) / 3.0)
                            .padding(.top, 10)
                        
                        // 3. Dynamic View Switcher
                        Group {
                            switch currentStep {
                            case 0:
                                WalkerOrSitterView()
                            case 1:
                                WalkersDetailsView()
                            case 2:
                                WalkersAvailabilityView()
                            default:
                                EmptyView()
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                    }
                    
                    // 4. Overlay "Continue" Logic
                    // Note: You can either put the button here or keep it inside the subviews.
                    // For a smooth flow, let's add a global "Next" trigger logic.
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if currentStep > 0 {
                            Button(action: {
                                withAnimation(.spring()) { currentStep -= 1 }
                            }) {
                                Image(systemName: "chevron.left")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Next") {
                            advanceStep()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    }
                }
            }
        }
    }
    
    private func advanceStep() {
        withAnimation(.spring()) {
            if currentStep < 2 {
                currentStep += 1
            } else {
                isOnboardingComplete = true
            }
        }
    }
}

// MARK: - Custom Progress Bar Component
struct OnboardingProgressBar: View {
    var progress: Double // Value between 0 and 1
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .frame(maxWidth: .infinity)
                .frame(height: 8)
                .foregroundColor(Color.orange.opacity(0.1))
            
            Capsule()
                .frame(width: UIScreen.main.bounds.width * CGFloat(progress) - 40)
                .frame(height: 8)
                .foregroundColor(.orange)
                .animation(.spring(), value: progress)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    WalkersOnboardingView()
}

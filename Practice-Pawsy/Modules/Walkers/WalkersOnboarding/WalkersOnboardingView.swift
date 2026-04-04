//
//  WalkersOnboardingView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkersOnboardingView: View {
    @State private var currentStep = 0
    // UPDATED: Changed total steps to 2
    let totalSteps = 2
    @State private var isOnboardingComplete = false
    
    // Walker-specific state variables
    @State private var fullName: String = ""
    @State private var phone: String = ""
    @State private var city: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var fromTime = Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()
    @State private var toTime = Calendar.current.date(from: DateComponents(hour: 18, minute: 30)) ?? Date()
    @State private var isAvailableOnShortNotice = true
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        if isOnboardingComplete {
            WalkersMainTabView()
        } else {
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // MARK: Progress Bar + Back Button
                    if currentStep < totalSteps {
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
                    Group {
                        switch currentStep {
                        case 0:
                            // UPDATED: Now starts directly with Details
                            WalkersDetailsView(
                                fullName: $fullName,
                                phone: $phone,
                                city: $city,
                                onNext: { withAnimation { currentStep = 1 } }
                            )
                        case 1:
                            // UPDATED: Now the final step
                            WalkersAvailabilityView(
                                selectedDays: $selectedDays,
                                fromTime: $fromTime,
                                toTime: $toTime,
                                isAvailableOnShortNotice: $isAvailableOnShortNotice,
                                onComplete: {
                                    withAnimation {
                                        isOnboardingComplete = true
                                        authVM.completeOnboarding()
                                    }
                                }
                            )
                        default:
                            EmptyView()
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
            }
        }
    }
}

#Preview {
    WalkersOnboardingView()
        .environmentObject(AuthViewModel())
}

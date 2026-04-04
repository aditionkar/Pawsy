//
//  LoadingAnimationView.swift
//  Pawsy
//

import SwiftUI

struct LoadingAnimationView: View {
    let selectedSymptoms: [String]
    let duration: String
    let appetite: String
    let energy: String
    @Binding var path: NavigationPath

    @State private var progress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var predictionCompleted = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color(.systemOrange).opacity(0.12))
                        .frame(width: 180, height: 180)
                        .scaleEffect(pulseScale)
                        .animation(
                            .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: pulseScale
                        )

                    Circle()
                        .stroke(Color(.systemOrange).opacity(0.2), lineWidth: 3)
                        .frame(width: 120, height: 120)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color(.systemOrange),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 2.4), value: progress)

                    Circle()
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(width: 100, height: 100)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(Color(.systemOrange))
                }

                VStack(spacing: 8) {
                    Text("Analyzing symptoms...")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)

                    Text("This will take a few seconds")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
        }
        .navigationTitle("Analyzing")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            pulseScale = 1.12
            progress = 1.0
            
            // Call REAL ML Model
            DispatchQueue.global(qos: .userInitiated).async {
                let result = SOSMLService.shared.predictRisk(
                    symptoms: selectedSymptoms.joined(separator: ", "),
                    duration: duration,
                    appetite: appetite,
                    energy: energy
                )
                
                DispatchQueue.main.async {
                    let riskLevel = mapToRiskLevel(result.label)
                    print("✅ REAL ML Prediction: \(result.label) with confidence: \(String(format: "%.2f", result.confidence))")
                    print("📊 Symptoms: \(selectedSymptoms)")
                    print("⏱️ Duration: \(duration)")
                    print("🍽️ Appetite: \(appetite)")
                    print("⚡ Energy: \(energy)")
                    
                    // Navigate to results with REAL prediction
                    path.removeLast()
                    path.append(SOSRoute.results(riskLevel, selectedSymptoms))
                    predictionCompleted = true
                }
            }
        }
    }
    
    private func mapToRiskLevel(_ label: String) -> RiskLevel {
        switch label {
        case "low":
            return .low
        case "moderate":
            return .moderate
        case "high":
            return .severe
        default:
            return .moderate
        }
    }
}

#Preview {
    LoadingAnimationView(
        selectedSymptoms: ["vomiting", "lethargy"],
        duration: "2 days",
        appetite: "low",
        energy: "low",
        path: .constant(NavigationPath())
    )
}

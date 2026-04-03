//
//  LoadingAnimationView.swift
//  Pawsy
//

import SwiftUI

struct LoadingAnimationView: View {
    let selectedSymptoms: [String]
    @Binding var path: NavigationPath

    @State private var progress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0

    var simulatedRiskLevel: RiskLevel {
        if selectedSymptoms.count >= 4 { return .severe }
        if selectedSymptoms.count >= 2 { return .moderate }
        return .low
    }

    var simulatedEvidence: [EvidenceItem] {
        selectedSymptoms.map { symptom in
            EvidenceItem(
                icon: iconForSymptom(symptom),
                title: "\(symptom) detected",
                description: descriptionForSymptom(symptom)
            )
        }
    }

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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                path.removeLast()
                path.append(SOSRoute.results(simulatedRiskLevel, simulatedEvidence))
            }
        }
    }

    private func iconForSymptom(_ symptom: String) -> String {
        switch symptom {
        case "Not eating": return "fork.knife"
        case "Vomiting": return "pills"
        case "Low energy": return "battery.25"
        case "Diarrhea": return "drop.triangle"
        case "Excessive barking": return "megaphone"
        case "Limping": return "figure.walk"
        default: return "exclamationmark.circle"
        }
    }

    private func descriptionForSymptom(_ symptom: String) -> String {
        switch symptom {
        case "Not eating": return "Loss of appetite reported for this session."
        case "Vomiting": return "Stomach upset or nausea indicated."
        case "Low energy": return "Activity levels appear lower than normal."
        case "Diarrhea": return "Loose stools or digestive discomfort reported."
        case "Excessive barking": return "Unusual vocalization may indicate discomfort."
        case "Limping": return "Mobility issue or pain in limbs detected."
        default: return "Additional symptom flagged for review."
        }
    }
}

#Preview {
    SOSView()
}

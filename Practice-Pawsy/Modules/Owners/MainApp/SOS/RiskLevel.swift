//
//  SOSResultsView.swift
//  Pawsy
//

import SwiftUI

struct SOSResultsView: View {
    let riskLevel: RiskLevel
    let evidenceItems: [String]
    @Binding var path: NavigationPath

    private func iconForSymptom(_ symptom: String) -> String {
        switch symptom.lowercased() {
        case "not eating", "loss of appetite", "appetite loss":
            return "fork.knife"
        case "vomiting":
            return "pills"
        case "lethargy", "low energy":
            return "battery.25"
        case "diarrhea":
            return "drop.triangle"
        case "coughing":
            return "lungs"
        case "fever":
            return "thermometer"
        case "limping", "lameness":
            return "figure.walk"
        case "nasal discharge":
            return "nose"
        case "eye discharge":
            return "eye"
        default:
            return "exclamationmark.circle"
        }
    }
    
    private func descriptionForSymptom(_ symptom: String) -> String {
        switch symptom.lowercased() {
        case "not eating", "loss of appetite", "appetite loss":
            return "Loss of appetite reported for this session."
        case "vomiting":
            return "Stomach upset or nausea indicated."
        case "lethargy", "low energy":
            return "Activity levels appear lower than normal."
        case "diarrhea":
            return "Loose stools or digestive discomfort reported."
        case "coughing":
            return "Respiratory issue or irritation detected."
        case "fever":
            return "Elevated body temperature detected."
        case "limping", "lameness":
            return "Mobility issue or pain in limbs detected."
        case "nasal discharge":
            return "Nasal congestion or discharge present."
        case "eye discharge":
            return "Eye irritation or infection indicated."
        default:
            return "Additional symptom flagged for review."
        }
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    // MARK: Status Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(riskLevel.iconColor.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: riskLevel.icon)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(riskLevel.iconColor)
                            }
                            Spacer()
                            Text("STATUS")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                                .kerning(1.2)
                        }

                        Text(riskLevel.title)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)

                        Text(riskLevel.alertLabel)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(20)

                    // MARK: Diagnosis Banner
                    VStack(alignment: .leading, spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(riskLevel.accentForeground.opacity(0.15))
                                .frame(width: 44, height: 44)
                            Image(systemName: "cross.case.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(riskLevel.accentForeground)
                        }

                        Text("'\(riskLevel.diagnosisText)'")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(riskLevel.accentForeground)

                        Capsule()
                            .fill(riskLevel.accentForeground.opacity(0.3))
                            .frame(width: 40, height: 3)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(riskLevel.accentColor)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(riskLevel.accentBorderColor, lineWidth: 1.5)
                    )

                    // MARK: Evidence & Reasoning
                    VStack(alignment: .leading, spacing: 16) {
                        Text("EVIDENCE & REASONING")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                            .kerning(1.2)

                        VStack(spacing: 0) {
                            ForEach(Array(evidenceItems.enumerated()), id: \.offset) { index, symptom in
                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.systemOrange).opacity(0.12))
                                            .frame(width: 36, height: 36)
                                        Image(systemName: iconForSymptom(symptom))
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(Color(.systemOrange))
                                    }

                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(symptom.capitalized)
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .foregroundColor(.primary)

                                        Text(descriptionForSymptom(symptom))
                                            .font(.system(size: 13, weight: .regular, design: .rounded))
                                            .foregroundColor(.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.vertical, 12)

                                if index < evidenceItems.count - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(20)

                    // MARK: Care Plan
                    VStack(spacing: 10) {
                        Text("CARE PLAN")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(.systemOrange))
                            .kerning(1.2)

                        Text("'\(riskLevel.carePlanTitle)'")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)

                        Text(riskLevel.carePlanDescription)
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(20)

                    Spacer(minLength: 32)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("SOS Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { path.removeLast() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemOrange))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    SOSResultsView(
        riskLevel: .severe,
        evidenceItems: ["Vomiting", "Lethargy", "Loss of appetite"],
        path: .constant(NavigationPath())
    )
}

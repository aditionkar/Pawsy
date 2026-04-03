//
//  PastChecksView.swift
//  Pawsy
//

import SwiftUI

struct PastCheck: Identifiable {
    let id = UUID()
    let date: Date
    let riskLevel: RiskLevel
    let symptoms: [String]
    let summary: String

    var evidenceItems: [EvidenceItem] {
        symptoms.map { symptom in
            EvidenceItem(
                icon: iconForSymptom(symptom),
                title: "\(symptom) detected",
                description: descriptionForSymptom(symptom)
            )
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

struct PastChecksView: View {
    @Binding var path: NavigationPath

    let pastChecks: [PastCheck] = [
        PastCheck(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 24))!,
            riskLevel: .low,
            symptoms: ["Low energy", "Not eating"],
            summary: "All vitals are within normal range. Pet showed playful behavior and healthy gum..."
        ),
        PastCheck(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!,
            riskLevel: .moderate,
            symptoms: ["Vomiting", "Diarrhea", "Low energy"],
            summary: "Mild digestive issue detected. Symptoms consistent with dietary intolerance..."
        ),
        PastCheck(
            date: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 3))!,
            riskLevel: .severe,
            symptoms: ["Limping", "Excessive barking"],
            summary: "Signs of acute pain detected in hind leg. Immediate veterinary attention was advised..."
        )
    ]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ForEach(pastChecks) { check in
                        Button(action: {
                            path.append(SOSRoute.results(check.riskLevel, check.evidenceItems))
                        }) {
                            PastCheckCard(check: check)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Past Checks")
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
    }
}

struct PastCheckCard: View {
    let check: PastCheck

    var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM dd, yyyy"
        return f.string(from: check.date).uppercased()
    }

    var riskColor: Color {
        switch check.riskLevel {
        case .low: return .green
        case .moderate: return .orange
        case .severe: return .red
        }
    }

    var riskLabel: String {
        switch check.riskLevel {
        case .low: return "LOW RISK"
        case .moderate: return "MODERATE"
        case .severe: return "SEVERE"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(formattedDate)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
                    .kerning(0.8)

                Spacer()

                HStack(spacing: 5) {
                    Circle()
                        .fill(riskColor)
                        .frame(width: 8, height: 8)
                    Text(riskLabel)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(riskColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(riskColor.opacity(0.1))
                .clipShape(Capsule())
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(check.symptoms, id: \.self) { symptom in
                        Text(symptom)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(Color(.systemOrange))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color(.systemOrange).opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }

            Text(check.summary)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            HStack {
                Text("View Full Report")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(.systemOrange))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}

#Preview {
    SOSView()
}

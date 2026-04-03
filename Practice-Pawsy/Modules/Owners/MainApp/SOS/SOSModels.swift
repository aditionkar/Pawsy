//
//  SOSModels.swift
//  Practice-Pawsy
//
//  Created by admin20 on 03/04/26.
//

//
//  SOSModels.swift
//  Pawsy
//

import SwiftUI

// MARK: - SOSRoute
enum SOSRoute: Hashable {
    case loading([String])
    case results(RiskLevel, [EvidenceItem])
    case pastChecks
}

// MARK: - RiskLevel
enum RiskLevel: Hashable {
    case low, moderate, severe

    var title: String {
        switch self {
        case .low: return "No Risk"
        case .moderate: return "Moderate Risk"
        case .severe: return "Severe Risk"
        }
    }

    var alertLabel: String {
        switch self {
        case .low: return "Green Alert Level"
        case .moderate: return "Yellow Alert Level"
        case .severe: return "Red Alert Level"
        }
    }

    var icon: String {
        switch self {
        case .low: return "checkmark.circle.fill"
        case .moderate: return "exclamationmark.triangle.fill"
        case .severe: return "xmark.octagon.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .low: return .green
        case .moderate: return .orange
        case .severe: return .red
        }
    }

    var accentColor: Color {
        switch self {
        case .low: return Color(.systemGreen).opacity(0.1)
        case .moderate: return Color(.systemOrange).opacity(0.1)
        case .severe: return Color(.systemRed).opacity(0.1)
        }
    }

    var accentBorderColor: Color {
        switch self {
        case .low: return Color(.systemGreen).opacity(0.35)
        case .moderate: return Color(.systemOrange).opacity(0.35)
        case .severe: return Color(.systemRed).opacity(0.35)
        }
    }

    var accentForeground: Color {
        switch self {
        case .low: return Color(.systemGreen)
        case .moderate: return Color(.systemOrange)
        case .severe: return Color(.systemRed)
        }
    }

    var diagnosisText: String {
        switch self {
        case .low: return "Your pet seems fine"
        case .moderate: return "May be a mild digestive issue"
        case .severe: return "Immediate attention required"
        }
    }

    var carePlanTitle: String {
        switch self {
        case .low: return "Home Care Recommended"
        case .moderate: return "Consult a vet soon"
        case .severe: return "Visit a vet immediately"
        }
    }

    var carePlanDescription: String {
        switch self {
        case .low: return "Monitor your pet at home. Ensure they stay hydrated and comfortable. Check in again if symptoms worsen."
        case .moderate: return "We recommend a professional check-up within the next 12–24 hours to prevent further complications."
        case .severe: return "Your pet needs urgent veterinary care. Please visit a vet clinic right away."
        }
    }
}

// MARK: - EvidenceItem
struct EvidenceItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String

    static func == (lhs: EvidenceItem, rhs: EvidenceItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

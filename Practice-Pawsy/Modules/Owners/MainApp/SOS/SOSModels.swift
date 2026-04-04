//
//  SOSModels.swift
//  Pawsy
//

import Foundation
import SwiftUI 
enum RiskLevel: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case severe = "Severe"
    
    var color: String {
        switch self {
        case .low: return "green"
        case .moderate: return "yellow"
        case .severe: return "red"
        }
    }
    
    var recommendation: String {
        switch self {
        case .low:
            return "Monitor at home. Schedule a vet visit if symptoms persist."
        case .moderate:
            return "Book a vet appointment within 24-48 hours."
        case .severe:
            return "Seek immediate veterinary care!"
        }
    }
    
    var title: String {
        switch self {
        case .low: return "Low Risk"
        case .moderate: return "Moderate Risk"
        case .severe: return "Severe Risk"
        }
    }
    
    var alertLabel: String {
        switch self {
        case .low: return "Mild symptoms detected"
        case .moderate: return "Monitor closely"
        case .severe: return "Urgent care recommended"
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "checkmark.circle.fill"
        case .moderate: return "exclamationmark.triangle.fill"
        case .severe: return "cross.case.fill"
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
        case .low: return Color.green.opacity(0.1)
        case .moderate: return Color.orange.opacity(0.1)
        case .severe: return Color.red.opacity(0.1)
        }
    }
    
    var accentForeground: Color {
        switch self {
        case .low: return .green
        case .moderate: return .orange
        case .severe: return .red
        }
    }
    
    var accentBorderColor: Color {
        switch self {
        case .low: return Color.green.opacity(0.3)
        case .moderate: return Color.orange.opacity(0.3)
        case .severe: return Color.red.opacity(0.3)
        }
    }
    
    var diagnosisText: String {
        switch self {
        case .low: return "Mild Condition"
        case .moderate: return "Moderate Condition"
        case .severe: return "Critical Condition"
        }
    }
    
    var carePlanTitle: String {
        switch self {
        case .low: return "Rest & Monitor"
        case .moderate: return "Vet Visit Recommended"
        case .severe: return "Emergency Care Needed"
        }
    }
    
    var carePlanDescription: String {
        switch self {
        case .low:
            return "Provide plenty of water and rest. Monitor for 24 hours."
        case .moderate:
            return "Schedule a vet appointment within 24-48 hours."
        case .severe:
            return "Take your pet to an emergency vet immediately!"
        }
    }
}

enum SOSRoute: Hashable {
    case details([String])
    case results(RiskLevel, [String])
    case pastChecks
    case loading(symptoms: [String], duration: String, appetite: String, energy: String)
}

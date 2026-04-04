//
//  SOSMLService.swift
//  Practice-Pawsy
//
//  Created by user@37 on 04/04/26.
//

import CoreML

class SOSMLService {
    
    static let shared = SOSMLService()
    
    private let model: PawsySOSModel?
    
    private init() {
        model = try? PawsySOSModel(configuration: MLModelConfiguration())
    }
    
    // MARK: - Convert symptoms string to one-hot encoded features
    
    private func extractSymptomFeatures(from symptomsString: String) -> [String: Double] {
        let symptomsList = symptomsString.lowercased().components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        
        print("🔍 Raw symptoms list: \(symptomsList)")
        
        let allSymptoms = [
            "fever", "lethargy", "appetite loss", "vomiting", "diarrhea",
            "coughing", "labored breathing", "nasal discharge", "eye discharge",
            "lameness", "skin lesions", "swelling", "weight loss", "dehydration",
            "bloody diarrhea", "abdominal pain", "wheezing", "blue gums",
            "seizures", "confusion", "tremors", "stumbling",
            "difficulty breathing", "fainting"
        ]
        
        var features: [String: Double] = [:]
        
        for symptom in allSymptoms {
            let symptomKey = symptom.replacingOccurrences(of: " ", with: "_")
            var found = false
            
            // Special case for appetite loss - matches "appetite loss", "loss of appetite", "not eating"
            if symptom == "appetite loss" {
                found = symptomsList.contains { userSymptom in
                    userSymptom.contains("appetite") ||
                    userSymptom.contains("loss of appetite") ||
                    userSymptom.contains("not eating") ||
                    userSymptom == "appetite loss"
                }
            }
            // Special case for lethargy - matches "lethargy" and "low energy"
            else if symptom == "lethargy" {
                found = symptomsList.contains { userSymptom in
                    userSymptom.contains("lethargy") ||
                    userSymptom.contains("low energy") ||
                    userSymptom == "lethargy"
                }
            }
            // Special case for lameness - matches "lameness" and "limping"
            else if symptom == "lameness" {
                found = symptomsList.contains { userSymptom in
                    userSymptom.contains("lameness") ||
                    userSymptom.contains("limping") ||
                    userSymptom == "lameness"
                }
            }
            // Normal matching
            else {
                found = symptomsList.contains { userSymptom in
                    userSymptom == symptom || userSymptom.contains(symptom) || symptom.contains(userSymptom)
                }
            }
            
            features[symptomKey] = found ? 1.0 : 0.0
        }
        
        // Debug: Print what was detected
        let detected = features.filter { $0.value == 1.0 }.map { $0.key }
        print("✅ Detected symptoms: \(detected)")
        print("📊 Total detected: \(detected.count) out of 24")
        
        return features
    }
    
    // MARK: - Convert duration to match training format
    
    private func normalizeDuration(_ duration: String) -> String {
        switch duration {
        case "1 day":
            return "2 days"
        case "2 days", "3 days":
            return duration
        default:
            return "3 days"
        }
    }
    
    // MARK: - Build input with all features
    
    private func buildInput(symptomFeatures: [String: Double], duration: String, appetite: String, energy: String) -> PawsySOSModelInput? {
        
        // Convert to Int64 (model expects integers)
        let fever = Int64(symptomFeatures["fever"] ?? 0)
        let lethargy = Int64(symptomFeatures["lethargy"] ?? 0)
        let appetiteLoss = Int64(symptomFeatures["appetite_loss"] ?? 0)
        let vomiting = Int64(symptomFeatures["vomiting"] ?? 0)
        let diarrhea = Int64(symptomFeatures["diarrhea"] ?? 0)
        let coughing = Int64(symptomFeatures["coughing"] ?? 0)
        let laboredBreathing = Int64(symptomFeatures["labored_breathing"] ?? 0)
        let nasalDischarge = Int64(symptomFeatures["nasal_discharge"] ?? 0)
        let eyeDischarge = Int64(symptomFeatures["eye_discharge"] ?? 0)
        let lameness = Int64(symptomFeatures["lameness"] ?? 0)
        let skinLesions = Int64(symptomFeatures["skin_lesions"] ?? 0)
        let swelling = Int64(symptomFeatures["swelling"] ?? 0)
        let weightLoss = Int64(symptomFeatures["weight_loss"] ?? 0)
        let dehydration = Int64(symptomFeatures["dehydration"] ?? 0)
        let bloodyDiarrhea = Int64(symptomFeatures["bloody_diarrhea"] ?? 0)
        let abdominalPain = Int64(symptomFeatures["abdominal_pain"] ?? 0)
        let wheezing = Int64(symptomFeatures["wheezing"] ?? 0)
        let blueGums = Int64(symptomFeatures["blue_gums"] ?? 0)
        let seizures = Int64(symptomFeatures["seizures"] ?? 0)
        let confusion = Int64(symptomFeatures["confusion"] ?? 0)
        let tremors = Int64(symptomFeatures["tremors"] ?? 0)
        let stumbling = Int64(symptomFeatures["stumbling"] ?? 0)
        let difficultyBreathing = Int64(symptomFeatures["difficulty_breathing"] ?? 0)
        let fainting = Int64(symptomFeatures["fainting"] ?? 0)
        
        let normalizedDuration = normalizeDuration(duration)
        
        print("📊 Input values:")
        print("   - Duration: \(normalizedDuration)")
        print("   - Appetite: \(appetite)")
        print("   - Energy: \(energy)")
        print("   - Fever: \(fever), Lethargy: \(lethargy), Appetite Loss: \(appetiteLoss)")
        print("   - Vomiting: \(vomiting), Diarrhea: \(diarrhea), Coughing: \(coughing)")
        
        return PawsySOSModelInput(
            fever: fever,
            lethargy: lethargy,
            appetite_loss: appetiteLoss,
            vomiting: vomiting,
            diarrhea: diarrhea,
            coughing: coughing,
            labored_breathing: laboredBreathing,
            nasal_discharge: nasalDischarge,
            eye_discharge: eyeDischarge,
            lameness: lameness,
            skin_lesions: skinLesions,
            swelling: swelling,
            weight_loss: weightLoss,
            dehydration: dehydration,
            bloody_diarrhea: bloodyDiarrhea,
            abdominal_pain: abdominalPain,
            wheezing: wheezing,
            blue_gums: blueGums,
            seizures: seizures,
            confusion: confusion,
            tremors: tremors,
            stumbling: stumbling,
            difficulty_breathing: difficultyBreathing,
            fainting: fainting,
            duration: normalizedDuration,
            appetite: appetite,
            energy: energy
        )
    }
    
    // MARK: - Predict risk
    
    func predictRisk(symptoms: String, duration: String, appetite: String, energy: String) -> (label: String, confidence: Double) {
        
        guard let model = model else {
            print("❌ Model not loaded")
            return ("unknown", 0.0)
        }
        
        print("\n📝 ===== NEW PREDICTION =====")
        print("📝 Symptoms string: \(symptoms)")
        print("📝 Duration: \(duration), Appetite: \(appetite), Energy: \(energy)")
        
        let symptomFeatures = extractSymptomFeatures(from: symptoms)
        
        guard let input = buildInput(symptomFeatures: symptomFeatures, duration: duration, appetite: appetite, energy: energy) else {
            print("❌ Failed to build input")
            return ("error", 0.0)
        }
        
        do {
            let output = try model.prediction(input: input)
            let confidence = output.labelProbability[output.label] ?? 0
            
            print("🎯 ===== PREDICTION RESULT =====")
            print("🎯 Label: \(output.label)")
            print("🎯 Confidence: \(String(format: "%.2f", confidence))")
            print("🎯 All probabilities: \(output.labelProbability)")
            print("================================\n")
            
            return (output.label, confidence)
            
        } catch {
            print("❌ Prediction error: \(error)")
            return ("error", 0.0)
        }
    }
}

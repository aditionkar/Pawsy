//
//  SOSView.swift
//  Pawsy
//

import SwiftUI

struct Symptom: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
}

struct SOSView: View {
    @State private var path = NavigationPath()
    @State private var selectedSymptoms = Set<UUID>()

    private let symptoms = [
        Symptom(title: "Vomiting", subtitle: "Stomach upset", systemImage: "pills"),
        Symptom(title: "Diarrhea", subtitle: "Loose stools", systemImage: "drop.triangle"),
        Symptom(title: "Lethargy", subtitle: "Low energy", systemImage: "battery.25"),
        Symptom(title: "Appetite loss", subtitle: "Not eating well", systemImage: "fork.knife"),  // ← Changed
        Symptom(title: "Coughing", subtitle: "Respiratory issue", systemImage: "lungs"),
        Symptom(title: "Fever", subtitle: "High body temperature", systemImage: "thermometer"),
        Symptom(title: "Lameness", subtitle: "Mobility issue", systemImage: "figure.walk"),  // ← Changed from "Limping"
        Symptom(title: "Nasal discharge", subtitle: "Runny nose", systemImage: "nose"),
        Symptom(title: "Eye discharge", subtitle: "Eye irritation", systemImage: "eye")
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var selectedSymptomTitles: [String] {
        symptoms
            .filter { selectedSymptoms.contains($0.id) }
            .map { $0.title.lowercased() }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottom) {

                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {

                        Text("What symptoms is your pet showing?")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 4)

                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(symptoms) { symptom in
                                Button(action: { toggleSymptom(symptom) }) {

                                    VStack(alignment: .leading, spacing: 10) {

                                        ZStack {
                                            Circle()
                                                .fill(Color(.systemGroupedBackground))
                                                .frame(width: 48, height: 48)

                                            Image(systemName: symptom.systemImage)
                                                .font(.title2)
                                                .foregroundColor(Color(.systemOrange))
                                        }

                                        Text(symptom.title)
                                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                                            .foregroundColor(.primary)

                                        Text(symptom.subtitle)
                                            .font(.system(size: 13, weight: .regular, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .cornerRadius(33)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 33)
                                            .strokeBorder(
                                                selectedSymptoms.contains(symptom.id)
                                                ? Color(.systemOrange)
                                                : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)

                        Spacer(minLength: 100)
                    }
                    .padding(.top, 8)
                }

                VStack {
                    Button(action: {
                        path.append(SOSRoute.details(selectedSymptomTitles))
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectedSymptoms.isEmpty ? Color(.systemGray4) : Color(.systemOrange))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .disabled(selectedSymptoms.isEmpty)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 36)
                    .padding(.top, 12)
                }
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            }
            .navigationTitle("SOS")
            .navigationBarTitleDisplayMode(.large)

            .navigationDestination(for: SOSRoute.self) { route in
                switch route {
                case .details(let symptoms):
                    DetailsView(symptoms: symptoms, path: $path)
                case .results(let riskLevel, let evidence):
                    SOSResultsView(riskLevel: riskLevel, evidenceItems: evidence, path: $path)
                case .pastChecks:
                    PastChecksView(path: $path)
                case .loading(let symptoms, let duration, let appetite, let energy):
                    LoadingAnimationView(
                        selectedSymptoms: symptoms,
                        duration: duration,
                        appetite: appetite,
                        energy: energy,
                        path: $path
                    )
                }
            }
        }
    }

    private func toggleSymptom(_ symptom: Symptom) {
        if selectedSymptoms.contains(symptom.id) {
            selectedSymptoms.remove(symptom.id)
        } else {
            selectedSymptoms.insert(symptom.id)
        }
    }
}

#Preview {
    SOSView()
}

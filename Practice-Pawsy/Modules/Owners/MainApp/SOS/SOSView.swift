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
    let isOther: Bool
}

struct SOSView: View {
    @State private var path = NavigationPath()
    @State private var selectedSymptoms = Set<UUID>()
    @State private var otherSymptomText = ""

    private let symptoms = [
        Symptom(title: "Not eating", subtitle: "Loss of appetite", systemImage: "fork.knife", isOther: false),
        Symptom(title: "Vomiting", subtitle: "Stomach upset", systemImage: "pills", isOther: false),
        Symptom(title: "Low energy", subtitle: "Lethargy or weakness", systemImage: "battery.25", isOther: false),
        Symptom(title: "Diarrhea", subtitle: "Loose stools", systemImage: "drop.triangle", isOther: false),
        Symptom(title: "Excessive barking", subtitle: "Unusual vocalization", systemImage: "megaphone", isOther: false),
        Symptom(title: "Limping", subtitle: "Mobility issues", systemImage: "figure.walk", isOther: false)
    ]

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var selectedSymptomTitles: [String] {
        symptoms.filter { selectedSymptoms.contains($0.id) }.map { $0.title }
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
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.secondarySystemGroupedBackground))
                                    .cornerRadius(33)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 33)
                                            .strokeBorder(
                                                selectedSymptoms.contains(symptom.id) ? Color(.systemOrange) : Color.clear,
                                                lineWidth: 2
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Other")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                                .padding(.horizontal)

                            TextField("Describe another symptom...", text: $otherSymptomText)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 18)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(Capsule())
                                .padding(.horizontal)
                        }

                        Spacer(minLength: 100)
                    }
                    .padding(.top, 8)
                }

                VStack {
                    Button(action: {
                        path.append(SOSRoute.loading(selectedSymptomTitles))
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectedSymptoms.isEmpty ? Color(.systemGray4) : Color(.systemOrange))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .animation(.easeInOut(duration: 0.2), value: selectedSymptoms.isEmpty)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { path.append(SOSRoute.pastChecks) }) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(Color(.systemOrange))
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(Circle())
                    }
                }
            }
            .navigationDestination(for: SOSRoute.self) { route in
                switch route {
                case .loading(let symptoms):
                    LoadingAnimationView(selectedSymptoms: symptoms, path: $path)
                case .results(let riskLevel, let evidence):
                    SOSResultsView(riskLevel: riskLevel, evidenceItems: evidence, path: $path)
                case .pastChecks:
                    PastChecksView(path: $path)
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

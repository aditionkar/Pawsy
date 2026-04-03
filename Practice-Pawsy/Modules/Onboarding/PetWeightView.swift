//
//  PetWeightView.swift
//  Pawsy
//

import SwiftUI

struct PetWeightView: View {
    @Binding var weight: Double
    let onDone: () -> Void

    @State private var totalDragOffset: CGFloat = 0
    let tickSpacing: CGFloat = 10
    let minWeight: Double = 1
    let maxWeight: Double = 80

    var body: some View {
        VStack(spacing: 0) {

            Text("Pet Info")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 64)

            VStack(spacing: 20) {

                // MARK: Weight Display
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", weight))
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                        .animation(.easeOut(duration: 0.08), value: weight)

                    Text("Kg")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                }

                // MARK: Ruler
                ZStack {
                    // Center orange indicator
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(.systemOrange))
                        .frame(width: 4, height: 56)
                        .zIndex(1)

                    GeometryReader { geo in
                        let totalTicks = Int((maxWeight - minWeight) * 10)

                        Canvas { context, size in
                            let centerX = size.width / 2
                            let offsetX = centerX - CGFloat((weight - minWeight) * 10) * tickSpacing + totalDragOffset

                            for i in 0...totalTicks {
                                let x = offsetX + CGFloat(i) * tickSpacing
                                guard x >= -tickSpacing && x <= size.width + tickSpacing else { continue }

                                let isMajor = i % 10 == 0
                                let isMid   = i % 5 == 0

                                let tickHeight: CGFloat = isMajor ? 44 : isMid ? 30 : 18
                                let tickWidth:  CGFloat = isMajor ? 4  : isMid ? 3  : 2.5

                                let cornerRadius: CGFloat = tickWidth / 2

                                let color: Color = isMajor
                                    ? Color(.label).opacity(0.75)
                                    : isMid
                                        ? Color(.secondaryLabel).opacity(0.6)
                                        : Color(.tertiaryLabel).opacity(0.5)

                                let rect = CGRect(
                                    x: x - tickWidth / 2,
                                    y: (size.height - tickHeight) / 2,
                                    width: tickWidth,
                                    height: tickHeight
                                )
                                let path = Path(roundedRect: rect, cornerRadius: cornerRadius)
                                context.fill(path, with: .color(color))
                            }
                        }
                        .frame(width: geo.size.width, height: 64)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let delta = value.translation.width - totalDragOffset
                                    let weightDelta = -delta / tickSpacing * 0.1
                                    let newWeight = weight + weightDelta
                                    let clamped = min(max(minWeight, newWeight), maxWeight)
                                    weight = (clamped * 10).rounded() / 10
                                    totalDragOffset = value.translation.width
                                }
                                .onEnded { _ in
                                    totalDragOffset = 0
                                }
                        )
                    }
                    .frame(height: 64)
                }
                .frame(height: 64)
            }
            .padding(.horizontal, 28)
            .padding(.top, 80)

            Spacer()

            Button(action: onDone) {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(Color(.systemOrange))
                    .clipShape(Capsule())
            }
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    PetWeightView(weight: .constant(12.9), onDone: {})
}

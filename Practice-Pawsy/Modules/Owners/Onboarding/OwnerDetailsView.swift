//
//  OwnerDetailsView.swift
//  Pawsy
//

import SwiftUI

struct OwnerDetailsView: View {
    @Binding var name: String
    @Binding var phone: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            Text("Pet Owner Info")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top, 64)

            VStack(spacing: 20) {
                TextField("Name", text: $name)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())

                TextField("Phone No", text: $phone)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .keyboardType(.phonePad)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 28)
            .padding(.top, 80
            )

            Spacer()

            Button(action: onNext) {
                Text("Next")
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
    OwnerDetailsView(name: .constant(""), phone: .constant(""), onNext: {})
}

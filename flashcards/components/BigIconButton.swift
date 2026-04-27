//
//  BigIconButton.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct BigIconButton: View {
    let iconSF: String
    let label: String
    let action: () -> Void
    var destructive: Bool = false

    var body: some View {
        Button(role: destructive ? .destructive : nil) {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 60)
                    .shadow(radius: 5, y: 5)
                    .padding([.leading, .trailing])

                HStack {
                    Image(systemName: iconSF)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                    Text(label)
                }

            }

        }
    }
}

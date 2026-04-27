//
//  Checkbox.swift
//  flashcards
//
//  Created by Sam Chamani on 23.04.26.
//

import SwiftUI

struct Checkbox: View {
    var isSelected: Bool
    var action: (() -> Void)?

    var body: some View {
        Button {
            action?()
        } label: {
            Image(
                systemName:
                    isSelected
                    ? "checkmark.circle.fill"
                    : "circle"
            )
            .foregroundColor(
                isSelected
                    ? .blue
                    : .secondary.opacity(0.5)
            )
            .font(.title2)
        }
    }
}

//
//  CardOneSide.swift
//  flashcards
//
//  Created by Sam Chamani on 23.04.26.
//

import SwiftUI

struct CardOneSide: View {
    @Binding var card: Card
    @FocusState.Binding var activeCard: FieldFocus?
    let focusIndex: Int

    var body: some View {
        VStack {
            TextField(
                "Side A",
                text: $card.sideA,
                axis: .vertical
            )
            .lineLimit(1...5)
            .multilineTextAlignment(.center)
            .focused($activeCard, equals: .sideA(row: focusIndex))

            Divider()

            TextField(
                "Side B",
                text: $card.sideB,
                axis: .vertical
            )
            .lineLimit(1...5)
            .multilineTextAlignment(.center)
            .focused($activeCard, equals: .sideB(row: focusIndex))

        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                Color(
                    .secondarySystemBackground
                )
            )
            .shadow(radius: 5, y: 5)
        )
    }
}

#Preview {

    @Previewable @State var card = Card(sideA: "", sideB: "")
    @Previewable @FocusState var activeCard: FieldFocus?
    
    CardOneSide(card: $card, activeCard: $activeCard, focusIndex: 0)
}

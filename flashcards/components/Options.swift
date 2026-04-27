//
//  Menu.swift
//  flashcards
//
//  Created by Sam Chamani on 13.10.25.
//

import SwiftUI

struct Options: View {
    @Binding var cardSet: CardSet
    var onChange: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    NavigationLink {
                        SetView(
                            cardSet: $cardSet,
                            onChange: {
                                onChange?()
                            }
                        )
                    } label: {
                        Label("Edit set", systemImage: "pencil")
                    }

                    Button {
                        onChange?()
                    } label: {
                        Label("Restart", systemImage: "arrow.clockwise")
                    }

                    Button {
                        cardSet.cards.shuffle()
                        onChange?()
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                    }

                    Button {
                        for i in cardSet.cards.indices {
                            let a = cardSet.cards[i].sideA
                            cardSet.cards[i].sideA = cardSet.cards[i].sideB
                            cardSet.cards[i].sideB = a
                        }
                        onChange?()
                    } label: {
                        Label(
                            "Flip cards",
                            systemImage: "arrow.triangle.2.circlepath"
                        )
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }

    }

}

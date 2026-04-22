//
//  Cards.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct Cards: View {
    @Binding var cards: [Card]
    @Binding var index: Int
    @Binding var isEditMode: Bool
    
    @State var markerOpacity: CGFloat = 0
    @State var bgCardsShift: CGFloat = 0
    
    let deckOffset: CGFloat = 10
    var maxVisibleBGCards: Int {
        if cards.count < 4 {
            return cards.count - 1
        }
        return 4
    }
    
    var body: some View {
        ZStack{
            if cards.isEmpty {
                Text("This stack is empty.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            else {
                if index + 1 < cards.count {
                    FlashCard(card: $cards[index + 1], isReadable: .constant(false), isEditMode: .constant(false))
                        .offset(y: deckOffset * CGFloat(maxVisibleBGCards))
                    ZStack {
                        ForEach(0..<maxVisibleBGCards, id: \.self) {
                            i in FlashCard(card: $cards[index + 1], isReadable: i == 0 && bgCardsShift != 0 ? .constant(true) : .constant(false), isEditMode: .constant(false))
                                .disabled(true)
                                .offset(x: 0, y: CGFloat(maxVisibleBGCards - i) * deckOffset)
                        }
                    }
                    .offset(y: bgCardsShift)
                    .animation(
                        .easeInOut(duration: 1), value: bgCardsShift
                    )
                    .onAnimationCompleted(for: bgCardsShift) {
                        if bgCardsShift != 0 {
                                // Create a transaction that disables animations
                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                
                                // Apply the reset inside this transaction
                                withTransaction(transaction) {
                                    bgCardsShift = 0
                                }
                            }
                    }
                }
                FlashCard(
                    card: $cards[index],
                    isReadable: .constant(true),
                    isEditMode: $isEditMode,
                    onLeft: {
                        index += 1
                        bgCardsShift = -deckOffset
                    },
                    onRight: {
                        index += 1
                        bgCardsShift = -deckOffset
                    },
                    onDrag: {percent in markerOpacity = percent}
                )
                
                HStack {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                        .overlay(
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        )
                        .opacity(-markerOpacity)
                    
                    Spacer()
                    
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                        .overlay(
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        )
                        .opacity(markerOpacity)
                    
                }
            }
        }
        
        
    }
}

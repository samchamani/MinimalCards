//
//  Stack.swift
//  flashcards
//
//  Created by Sam Chamani on 22.04.26.
//

import SwiftUI

struct Stack: View {
    @Binding var cards: [Card]
    @Binding var index: Int
    
    @State var showASide: Bool = true
    @State var isFrontReadable: Bool = true
    @State var offset: CGSize = .zero
    @State var offScreenCardOffset: CGSize = .init(
        width: -1000,
        height: 0
    )
    @State var stackOffset: CGSize = .zero

    var deckOffset: CGFloat = 10
    var maxVisibleBGCards: Int = 4
    var screenWidth = UIScreen.main.bounds.width
    
    var onRight: (() -> Void)?
    var onLeft: (() -> Void)?
    var onDrag: ((CGFloat) -> Void)?

    var body: some View {
        let minSwipe = screenWidth / 4
        let cardsLeft = cards.count - index
        let cardsInStack = min(maxVisibleBGCards, cardsLeft)

        ZStack {

            // Offscreen card
            FlippableCard(
                card: $cards[index],
                showA: .constant(true),
                isReadable: $isFrontReadable,
            )
            .rotationEffect(.degrees(offScreenCardOffset.width / 8))
            .offset(offScreenCardOffset)

            // Stacked Cards
            if cardsLeft > 1 {
                if cardsLeft > maxVisibleBGCards {
                    FlippableCard(
                        card: $cards[index + 1],
                        showA: .constant(true),
                        isReadable: .constant(false),
                    )
                        .offset(x: 0, y: CGFloat(cardsInStack) * deckOffset)
                }
                ForEach(1..<cardsInStack, id: \.self) {
                    i in
                    FlippableCard(
                        card: $cards[index + 1],
                        showA: .constant(true),
                        isReadable: .constant(false),
                    )
                    .offset(x: 0, y: CGFloat(cardsInStack - i) * deckOffset)
                }.offset(stackOffset)
            }

            // Front card and controller of animation
            FlippableCard(
                card: $cards[index],
                showA: $showASide,
                isReadable: $isFrontReadable,
            )
            .rotationEffect(.degrees(offset.width / 8))
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        
                            offset = gesture.translation
                            let direction = offset.width > 0.0 ? 1.0 : -1.0
                            let dragPercent = direction * min(abs(offset.width), minSwipe) / minSwipe
                            onDrag?(dragPercent)

                    }
                    .onEnded { _ in
                        onDrag?(0)
                        if offset.width > minSwipe {
                            withAnimation(.linear(duration: 0.2)) {
                                offset.width = screenWidth * 1.2
                                onRight?()
                            } completion: {
                                if index < cards.count - 1 {
                                    index = index + 1
                                    offset = .init(width: 0, height: deckOffset)
                                    stackOffset = .init(
                                        width: 0,
                                        height: deckOffset
                                    )
                                    showASide = true
                                    isFrontReadable = false
                                    withAnimation(.linear(duration: 0.1)) {
                                        offset = .zero
                                        stackOffset = .zero
                                        isFrontReadable = true
                                    }
                                }
                            }
                        } else if offset.width < -minSwipe {
                            withAnimation(.linear(duration: 0.2)) {
                                offScreenCardOffset.width = -screenWidth * 1.2
                                offset.width = -screenWidth * 1.2
                                offset.height = -100
                                onLeft?()
                            } completion: {
                                showASide = true
                                isFrontReadable = false
                                withAnimation(.linear(duration: 0.2)) {
                                    offScreenCardOffset.width = .zero
                                } completion: {
                                    let firstItem = cards.remove(at: index)
                                    cards.append(firstItem)
                                    offset = .init(width: 0, height: deckOffset)
                                    stackOffset = .init(
                                        width: 0,
                                        height: deckOffset
                                    )
                                    offScreenCardOffset = .init(
                                        width: -screenWidth * 1.2,
                                        height: CGFloat(cardsInStack)
                                            * deckOffset
                                    )
                                    withAnimation(.linear(duration: 0.1)) {
                                        offset = .zero
                                        stackOffset = .zero
                                        isFrontReadable = true
                                    }
                                }

                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = .zero
                            }

                        }
                    }

            )
        }
    }
}

#Preview {

    @Previewable @State var mockIndex = 0
    @Previewable @State var mockCards = [
        Card(sideA: "ajgukgkgk", sideB: "bjkhkjhjk"),
        Card(sideA: "c", sideB: "d"),
                Card(sideA: "e", sideB: "f"),
//                Card(sideA: "h", sideB: "g"),
//                Card(sideA: "a", sideB: "b"),
//                Card(sideA: "c", sideB: "d"),
//                Card(sideA: "e", sideB: "f"),
//                Card(sideA: "h", sideB: "g"),
//                Card(sideA: "a", sideB: "b"),
//                Card(sideA: "c", sideB: "d"),
//                Card(sideA: "e", sideB: "f"),
//                Card(sideA: "h", sideB: "g"),
//                Card(sideA: "a", sideB: "b"),
//                Card(sideA: "c", sideB: "d"),
//                Card(sideA: "e", sideB: "f"),
//                Card(sideA: "h", sideB: "g"),

    ]

    ZStack {
        Stack(
            cards: $mockCards,
            index: $mockIndex,
        )
    }.padding([.leading, .trailing], 10)
}

//
//  StartView 2.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct CardsView: View {
    @Binding var cardSet: CardSet

    @State var correctOnes: Int
    @State var markerOpacity: Double = 0.0
    @State var signalOpacity: CGFloat = 0

    @State private var showMistakePopup: Bool = false
    @State private var showExporter = false
    @State private var csvDocument: CSVDocument?
    @State private var exportPhase: ExportPhase = .currentDeck

    private enum ExportPhase {
        case currentDeck
        case mistakeDeck
    }

    init(cardSet: Binding<CardSet>) {
        self._cardSet = cardSet
        self._correctOnes = State(initialValue: cardSet.wrappedValue.index)
    }

    let generator = UINotificationFeedbackGenerator()

    var body: some View {
        let progress = Double(correctOnes) / max(Double(cardSet.cards.count), 1)

        ZStack {
            Background()

            VStack {
                Progressbar(progress: progress)
                Spacer()
                if cardSet.cards.isEmpty {
                    Text("No cards yet.")
                    NavigationLink {
                        SetView(
                            cardSet: $cardSet,
                            onChange: {
                                cardSet.index = 0
                                correctOnes = 0
                            }
                        )
                    } label: {
                        Text("Create some cards")
                    }
                } else if correctOnes == cardSet.cards.count {

                    Text(cardSet.mistakeCards.isEmpty ? "Perfect!" : "Nice.")
                        .font(.title)
                        .italic()
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()

                    BigIconButton(
                        iconSF: "arrow.clockwise",
                        label: "Repeat all",
                        action: {
                            cardSet.mistakeCards = Set<Card>()
                            cardSet.index = 0
                            correctOnes = 0
                        }
                    )

                    if !cardSet.mistakeCards.isEmpty {
                        BigIconButton(
                            iconSF: "plus",
                            label: "Create a mistake deck",
                            action: {
                                let mistakeSet = CardSet(
                                    name: cardSet.name + " (Mistakes)",
                                    cards: Array(cardSet.mistakeCards)
                                )
                                exportPhase = .mistakeDeck
                                csvDocument = CSVDocument(
                                    data: Data(StorageManager.csvString(from: mistakeSet).utf8)
                                )
                                showExporter = true
                            }
                        )
                    }

                } else {
                    Stack(
                        cards: $cardSet.cards,
                        index: $cardSet.index,
                        onRight: {
                            correctOnes += 1
                            generator.notificationOccurred(.success)
                            withAnimation(.linear(duration: 0.2)) {
                                signalOpacity = 1
                            } completion: {
                                withAnimation(.linear(duration: 0.2)) {
                                    signalOpacity = 0
                                }
                            }
                        },
                        onLeft: {
                            cardSet.mistakeCards.insert(
                                cardSet.cards[cardSet.index]
                            )
                            generator.notificationOccurred(.error)
                            withAnimation(.linear(duration: 0.2)) {
                                signalOpacity = -1
                            } completion: {
                                withAnimation(.linear(duration: 0.2)) {
                                    signalOpacity = 0
                                }
                            }
                        },
                        onDrag: { dragOffset in
                            markerOpacity = dragOffset
                        },
                    )
                }

                Spacer()
            }
            .padding([.leading, .trailing], 10)

            Markers(markerOpacity: $markerOpacity)
            SignalFrame(color: Color.green).opacity(signalOpacity)
            SignalFrame(color: Color.red).opacity(signalOpacity * -1)

        }
        .navigationTitle(cardSet.name)
        .fileExporter(
            isPresented: $showExporter,
            document: csvDocument,
            contentType: .commaSeparatedText,
            defaultFilename: exportPhase == .currentDeck
                ? cardSet.name
                : "\(cardSet.name) (Mistakes)"
        ) { result in
            switch result {
            case .success(let savedURL):
                if exportPhase == .currentDeck {
                    let mistakeSet = CardSet(
                        name: cardSet.name + " (Mistakes)",
                        cards: Array(cardSet.mistakeCards)
                    )
                    csvDocument = CSVDocument(
                        data: Data(StorageManager.csvString(from: mistakeSet).utf8)
                    )
                    exportPhase = .mistakeDeck
                    showExporter = true
                } else {
                    StorageManager.saveBookmark(from: savedURL)
                    cardSet.name = savedURL.deletingPathExtension().lastPathComponent
                    cardSet.cards = Array(cardSet.mistakeCards)
                    cardSet.mistakeCards = Set<Card>()
                    cardSet.index = 0
                    correctOnes = 0
                    exportPhase = .currentDeck
                }
            case .failure(let error):
                print("Failed to save file:", error)
            }
        }
        Options(
            cardSet: $cardSet,
            onChange: {
                cardSet.index = 0
                correctOnes = 0
            }
        )

    }

}

#Preview {

    @Previewable @State var cardSet = CardSet(
        name: "New Set",
        cards: [
            Card(sideA: "Questiossasasan?", sideB: "Answer!"),
            Card(sideA: "Questioasasassassan?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
        ]

    )

    NavigationStack {
        CardsView(
            cardSet: $cardSet
        )
    }
}

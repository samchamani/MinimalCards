//
//  SetView.swift
//  flashcards
//
//  Created by Sam Chamani on 22.04.26.
//

import SwiftUI

struct SetView: View {
    @Binding var cardSet: CardSet

    var onChange: (() -> Void)?
    
    @State private var selectedIDs = Set<UUID>()
    @State private var showExporter = false
    @State private var csvDocument: CSVDocument?

    var body: some View {
        ZStack {
            Background()
            VStack {
                
                TextField("Deck title", text: $cardSet.name)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .submitLabel(.done)
                    .padding()

                CardOneSideList(
                    cards: $cardSet.cards,
                    selectedIDs: $selectedIDs,
                    onChange: {
                        onChange?()
                    }
                )
            }
        }
        .navigationTitle("Edit Deck")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        let csvText = generateCSVString(cardSet: cardSet)
                        csvDocument = CSVDocument(
                            data: Data(csvText.utf8)
                        )
                        showExporter = true
                    } label: {
                        Label(
                            "Export set",
                            systemImage: "square.and.arrow.down"
                        )
                    }

                    Button(role: .destructive) {
                        cardSet.cards.removeAll {
                            card in
                            selectedIDs.contains(card.id)

                        }
                        selectedIDs.removeAll()
                        onChange?()
                    } label: {
                        Label(
                            "Delete \(selectedIDs.count) cards",
                            systemImage: "trash"
                        )
                    }
                    .disabled(selectedIDs.isEmpty)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .imageScale(.large)
                }
                .fileExporter(
                    isPresented: $showExporter,
                    document: csvDocument,
                    contentType: .commaSeparatedText,
                    defaultFilename: "\(cardSet.name)"
                ) { result in
                    switch result {
                    case .success:
                        print("File saved!")
                    case .failure(let error):
                        print("Failed to save file:", error)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var cardSet = CardSet(
        name: "New Set",
        cards: [
            Card(sideA: "Questiossasasan?", sideB: "Answer!"),
            Card(sideA: "Questioasasassassan?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
            Card(sideA: "Question?", sideB: "Answer!"),
        ]

    )

    NavigationStack {
        SetView(
            cardSet: $cardSet
        )
    }
}

func generateCSVString(cardSet: CardSet) -> String {
    var csvText = ""
    for card in cardSet.cards {
        let escapedSideA =
            "\"\(card.sideA.replacingOccurrences(of: "\"", with: "\"\""))\""
        let escapedSideB =
            "\"\(card.sideB.replacingOccurrences(of: "\"", with: "\"\""))\""
        csvText +=
            "\(escapedSideA),\(escapedSideB)\n"
    }
    return csvText
}

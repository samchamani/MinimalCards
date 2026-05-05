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
            CardOneSideList(
                cards: $cardSet.cards,
                selectedIDs: $selectedIDs,
                onChange: {
                    onChange?()
                }
            )
            
        }
        .navigationTitle("Edit Deck")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        csvDocument = CSVDocument(
                            data: Data(StorageManager.csvString(from: cardSet).utf8)
                        )
                        showExporter = true
                    } label: {
                        Label(
                            "Export set",
                            systemImage: "square.and.arrow.down"
                        )
                    }

                    Button(role: .destructive) {
                        cardSet.cards.removeAll { selectedIDs.contains($0.id) }
                        cardSet.index = min(cardSet.index, max(0, cardSet.cards.count - 1))
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
                    case .success(let savedURL):
                        StorageManager.saveBookmark(from: savedURL)
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

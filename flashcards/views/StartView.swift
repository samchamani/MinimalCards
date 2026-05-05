//
//  StartView.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftCSV
import SwiftUI

struct StartView: View {
    @Binding var showCardsView: Bool
    @Binding var cardSet: CardSet

    @State private var showImporter = false
    @State private var showExporter = false
    @State private var csvDocument: CSVDocument?

    var body: some View {
        ZStack {
            Background()
            VStack {
                Spacer()
                Text("MinimalCards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(
                            colors: [.accentColor, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .mask(
                            Text("MinimalCards")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        )
                    )
                    .padding()
                Spacer()

                BigIconButton(
                    iconSF: "plus",
                    label: "New",
                    action: {
                        StorageManager.clearBookmark()
                        cardSet = CardSet(name: "New Deck", cards: [])
                        csvDocument = CSVDocument(
                            data: Data(StorageManager.csvString(from: cardSet).utf8)
                        )
                        showExporter = true
                    }
                )

                BigIconButton(
                    iconSF: "rectangle.stack",
                    label: "Open",
                    action: {
                        showImporter = true
                    }
                )

                BigIconButton(
                    iconSF: "arrow.clockwise",
                    label: "Continue",
                    action: {
                        showCardsView = true
                    }
                ).disabled(cardSet.cards.isEmpty)

                Spacer()
            }
        }
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.commaSeparatedText],
            allowsMultipleSelection: true
        ) { result in
            do {
                let urls = try result.get()
                let setName: String
                if urls.count == 1, let first = urls.first {
                    setName = first.lastPathComponent
                        .replacingOccurrences(
                            of: ".csv",
                            with: "",
                            options: .caseInsensitive
                        )
                } else {
                    setName = "Mixed Deck"
                }
                var loadedSet: CardSet = CardSet(name: setName, cards: [])
                for url in urls {
                    guard url.startAccessingSecurityScopedResource() else {
                        print("Could not access file: \(url.lastPathComponent)")
                        return
                    }
                    defer { url.stopAccessingSecurityScopedResource() }

                    let csv = try EnumeratedCSV(url: url, loadColumns: false)

                    if csv.header.count >= 2 {
                        let firstSideA = csv.header[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let firstSideB = csv.header[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        loadedSet.cards.append(Card(sideA: firstSideA, sideB: firstSideB))
                    }
                    for row in csv.rows {
                        let sideA = row[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        let sideB = row[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        loadedSet.cards.append(Card(sideA: sideA, sideB: sideB))
                    }

                    if urls.count == 1 {
                        StorageManager.saveBookmark(from: url)
                    }
                }
                cardSet = loadedSet

                if urls.count > 1 {
                    csvDocument = CSVDocument(
                        data: Data(StorageManager.csvString(from: loadedSet).utf8)
                    )
                    showExporter = true
                } else {
                    showCardsView = true
                }
            } catch {
                print("Failed file selection:", error)
            }
        }
        .fileExporter(
            isPresented: $showExporter,
            document: csvDocument,
            contentType: .commaSeparatedText,
            defaultFilename: cardSet.name
        ) { result in
            showExporter = false
            if case .success(let savedURL) = result {
                StorageManager.saveBookmark(from: savedURL)
                cardSet.name = savedURL.deletingPathExtension().lastPathComponent
                showCardsView = true
            }
        }
    }
}

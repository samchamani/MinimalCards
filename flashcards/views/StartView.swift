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

    @State private var splashVisible = true
    @State private var showButtons = false
    @State private var hasAnimated = false

    var body: some View {
        ZStack {
            Background()

            // Final layout
            VStack {
                Spacer()
                VStack {
                    Image("LaunchIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    Text("MinimalCards")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
                .opacity(showButtons ? 1 : 0)
                .animation(.easeOut(duration: 0.25), value: showButtons)
                
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
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 20)
                .animation(.spring(response: 0.45, dampingFraction: 0.8), value: showButtons)

                BigIconButton(
                    iconSF: "rectangle.stack",
                    label: "Open",
                    action: {
                        showImporter = true
                    }
                )
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 20)
                .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.07), value: showButtons)

                BigIconButton(
                    iconSF: "arrow.clockwise",
                    label: "Continue",
                    action: {
                        showCardsView = true
                    }
                )
                .disabled(cardSet.cards.isEmpty)
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 20)
                .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.14), value: showButtons)

                Spacer()
            }

            // Splash overlay
            if splashVisible {
                ZStack {
                    Color(.secondarySystemBackground).ignoresSafeArea()
                    VStack {
                        Spacer()
                        Image("LaunchIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Text("MinimalCards")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                }
                .transition(.move(edge: .top))
            }
        }
        .onAppear {
            guard !hasAnimated else { return }
            hasAnimated = true
            withAnimation(.easeInOut(duration: 0.5)) {
                splashVisible = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                showButtons = true
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

//
//  StorageManager.swift
//  flashcards
//
//  Created by Sam Chamani on 27.04.26.
//


import Foundation

class StorageManager {
    static let saveURL = URL.documentsDirectory.appending(path: "saved_flashcards.json")
    static let bookmarkKey = "linkedFileBookmark"

    static func save(cardSet: CardSet) {
        do {
            let data = try JSONEncoder().encode(cardSet)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to save cards: \(error.localizedDescription)")
        }
    }

    static func load() -> CardSet {
        do {
            let data = try Data(contentsOf: saveURL)
            let decodedCards = try JSONDecoder().decode(CardSet.self, from: data)
            return decodedCards
        } catch {
            print("No saved data found, starting fresh.")
            return CardSet(name: "New Deck", cards: [])
        }
    }

    static func saveBookmark(from url: URL) {
        _ = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }
        do {
            let data = try url.bookmarkData(options: [], includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(data, forKey: bookmarkKey)
        } catch {
            print("Failed to save bookmark: \(error)")
        }
    }

    static func clearBookmark() {
        UserDefaults.standard.removeObject(forKey: bookmarkKey)
    }

    static func syncToLinkedFile(cardSet: CardSet) {
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmarkKey) else { return }
        do {
            var isStale = false
            let url = try URL(
                resolvingBookmarkData: bookmarkData,
                options: [],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            if isStale {
                saveBookmark(from: url)
            }
            _ = url.startAccessingSecurityScopedResource()
            defer { url.stopAccessingSecurityScopedResource() }
            try csvString(from: cardSet).write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to sync to linked file: \(error)")
        }
    }

    static func csvString(from cardSet: CardSet) -> String {
        var result = ""
        for card in cardSet.cards {
            let a = "\"\(card.sideA.replacingOccurrences(of: "\"", with: "\"\""))\""
            let b = "\"\(card.sideB.replacingOccurrences(of: "\"", with: "\"\""))\""
            result += "\(a),\(b)\n"
        }
        return result
    }
}

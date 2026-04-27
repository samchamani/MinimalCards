//
//  StorageManager.swift
//  flashcards
//
//  Created by Sam Chamani on 27.04.26.
//


import Foundation

class StorageManager {
    static let saveURL = URL.documentsDirectory.appending(path: "saved_flashcards.json")
    
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
}

//
//  types.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct CardSet: Identifiable, Codable {
    var id: UUID = UUID()
    var index: Int = 0
    var name: String
    var cards: [Card]
    var mistakeCards : Set<Card> = Set<Card>()
}
struct Card: Hashable, Identifiable, Codable {
    var id: UUID = UUID()
    var sideA: String
    var sideB: String
}

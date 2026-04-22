//
//  types.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct CardSet {
    var name: String;
    var cards: [Card]
}
struct Card {
    var sideA: String;
    var sideB: String;
}

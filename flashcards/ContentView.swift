//
//  ContentView.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct ContentView: View {
    @State private var showCardsView = false
    @State private var cardSet = CardSet(
        name: "New Set", cards: [Card(sideA: "", sideB: "")]
    )
    
    var body: some View {
        NavigationStack {
            
            StartView(showCardsView: $showCardsView, cardSet: $cardSet)
                .navigationDestination( isPresented: $showCardsView){
                CardsView(cardSet: $cardSet)
                }
                .navigationTitle("")
            
        }
        
    }
}

#Preview {
    ContentView()
}

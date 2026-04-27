//
//  ContentView.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct ContentView: View {
    @State private var showCardsView = false
    
    @State private var cardSet: CardSet = StorageManager.load()
    
    @Environment(\.scenePhase) private var scenePhase
      
    var body: some View {

        NavigationStack {
            
            StartView(showCardsView: $showCardsView, cardSet: $cardSet)
                .navigationDestination( isPresented: $showCardsView){
                    CardsView(cardSet: $cardSet).navigationBarBackButtonHidden()
                }
                .navigationTitle("")
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .background || newPhase == .inactive {
                        StorageManager.save(cardSet: cardSet)
                    }
                }
            
        }
        
    }
}

#Preview {
    ContentView()
}

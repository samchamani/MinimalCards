//
//  Background.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct Background: View {
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            LinearGradient(
                gradient:
                    Gradient(colors: [
                        Color(.secondarySystemBackground),
                        Color(.systemBackground).opacity(0.8),
                        Color(.secondarySystemBackground)
                    ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
        
    }
    
}

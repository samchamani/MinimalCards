//
//  BigIconButton.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI

struct BigIconButton: View {
    let iconSF: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action:{
            action()
        }){
            VStack {
                Image(systemName: iconSF)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .overlay(
                        Circle().stroke(Color.accentColor).frame(width: 60, height: 60)
                    )
                    .padding(25)
                Text(label)
            }
        }
    }
}

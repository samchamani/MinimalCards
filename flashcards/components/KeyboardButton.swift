//
//  CloseKeyboardButton.swift
//  flashcards
//
//  Created by Sam Chamani on 23.04.26.
//

import SwiftUI

struct KeyboardButton: View {
    
    var icon: String = "keyboard.chevron.compact.down"
    var action: (() -> Void)?
    
    
    var body: some View {
        Button() {
            action?()
        } label: {
            Image(systemName: icon)
                .imageScale(.large)
        }
    }
}

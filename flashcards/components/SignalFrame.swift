//
//  SignalFrame.swift
//  flashcards
//
//  Created by Sam Chamani on 22.04.26.
//

import SwiftUI

struct SignalFrame: View {
    var color: Color = Color.green

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 80 )
                .stroke(color, lineWidth: 30)
                .blur(radius: 19)
                .ignoresSafeArea()
        }
    }

}

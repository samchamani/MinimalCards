//
//  Markers.swift
//  flashcards
//
//  Created by Sam Chamani on 22.04.26.
//

import SwiftUI

struct Markers: View {
    @Binding var markerOpacity: Double
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.red)
                .overlay(
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                )
                .opacity(-markerOpacity)
            Spacer()
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
                .overlay(
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                )
                .opacity(markerOpacity)
        }.animation(.spring(), value: markerOpacity)
    }
}

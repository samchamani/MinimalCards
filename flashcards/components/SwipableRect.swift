//
//  SwipableRectangle.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//


import SwiftUI

struct SwipableRect: View {
    let rect: RoundedRectangle
    @State private var offset = CGSize.zero // track drag offset
    
    var body: some View {
        rect
            .offset(x: offset.width, y: offset.height) // move rectangle
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        // Optional: reset position after swipe
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
            )
    }
}

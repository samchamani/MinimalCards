//
//  Progressbar.swift
//  flashcards
//
//  Created by Sam Chamani on 13.10.25.
//

import SwiftUI

struct Progressbar: View {
    var progress: Double
    
    @State private var progressbarWidth: CGFloat = 0
    var body: some View {
        let progressWidth: CGFloat = min(max(0, progressbarWidth * progress),progressbarWidth)
        
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemGray6))
            .frame(height:15)
            .background(GeometryReader { geo in
                Color.clear
                    .preference(key: ProgressBarWidth.self, value: geo.size.width)
            })
            .onPreferenceChange(ProgressBarWidth.self) { width in
                progressbarWidth = width
            }
            .overlay(
                HStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [
                            Color(.systemGreen).opacity(0.5),
                            Color(.systemGreen),
                        ], startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: progressWidth)
                        .animation(.linear, value: progressWidth)
                    Spacer()
                }
            )
            .padding()
    }
}

struct ProgressBarWidth: PreferenceKey {
    static var defaultValue: CGFloat = 40
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

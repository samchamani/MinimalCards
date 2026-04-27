//
//  FlippableCard.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI
import UIKit

struct FlippableCard: View {
    @Binding var card: Card
    @Binding var showA: Bool
    @Binding var isReadable: Bool

    @State private var degree = 0.0

    let height: CGFloat = 300
    let radius: CGFloat = 20
    let blurRadius: CGFloat = 5

    let generator = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        let readable = isReadable ? 0 : blurRadius

        ZStack {

            Text(card.sideA)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .blur(radius: readable)
                .background(
                    RoundedRectangle(cornerRadius: radius)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(radius: 5, y: 5)
                )
                .opacity(!showA ? 0 : 1)

            Text(card.sideB)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .blur(radius: readable)
                .background(
                    RoundedRectangle(cornerRadius: radius)
                        .fill(Color(.secondarySystemBackground))
                        .shadow(radius: 5, y: 5)
                )
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(showA ? 0 : 1)

        }
        .onAppear {
            degree = showA ? 0.0 : 180.0
        }
        .onChange(of: showA) { _,newShowA in
            degree = newShowA ? 0.0 : 180.0

        }
        .rotation3DEffect(
            .degrees(degree),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            if isReadable {
                generator.impactOccurred()
                let direction = showA ? 1.0 : -1.0
                withAnimation(.easeIn(duration: 0.2)) {
                    degree += direction * 90
                } completion: {
                    showA.toggle()
                    withAnimation(.easeOut(duration: 0.2)) {
                        degree += direction * 90
                    }
                }

            }
        }
    }
}

#Preview {

    @Previewable @State var showA: Bool = false

    ZStack {
        Background()
        FlippableCard(
            card: .constant(
                Card(sideA: "Qasdkl\n lsdaksdl; \n\n\n djlksjdlj ", sideB: "유로")
            ),
            showA: $showA,
            isReadable: .constant(true)
        ).padding()
    }

}

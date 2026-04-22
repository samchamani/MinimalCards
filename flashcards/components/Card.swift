//
//  Cards 2.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//


import SwiftUI
import UIKit

struct FlashCard: View {
    
    var height: CGFloat = 300
    var radius: CGFloat = 20
    var blurRadius: CGFloat = 5
    

    
    @Binding var card: Card
    @Binding var isReadable: Bool
    @State var flipped: Bool = false
    @State var offset: CGSize = .zero
    
    @Binding var isEditMode: Bool
    
    
    
    var onLeft: (() -> Void)?
    var onRight: (() -> Void)?
    var onDrag: ((CGFloat) -> Void)?
    
    @State private var pressCount: Int = 0
    @State private var isPressing: Bool = false
    @State private var screenWidth = UIScreen.main.bounds.width
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    
    var body: some View {
        let minSwipe = screenWidth / 4
        let readable = isReadable ? 0 : blurRadius
        
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(Color(.secondarySystemBackground))
                .frame(height: height)
                .overlay(
                    AutoHeightTextEditor(
                        text: $card.sideA,
                        maxHeight: height - 70,
                        isEditMode: $isEditMode,
                        placeholder: .constant("Side A")
                    )
                    .background(Color(.secondarySystemBackground))
                    .blur(radius: readable)
                    .animation(.easeInOut(duration: 1), value: readable)
                )
                .opacity(flipped ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: flipped)
            
            RoundedRectangle(cornerRadius: radius)
                .fill(Color.clear)
                .frame(height: height)
                .overlay(
                    AutoHeightTextEditor(
                        text: $card.sideB,
                        maxHeight: height - 70,
                        isEditMode: $isEditMode,
                        placeholder: .constant("Side B")
                    )
                    .blur(radius: isReadable ? 0 : blurRadius)
                    .animation(.easeInOut(duration: 0.5), value: isReadable)
                )
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(flipped ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: flipped)

        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .compositingGroup()
        .shadow(radius: 5, y: 5)
        .offset(x: flipped ? -offset.width : offset.width, y: offset.height / 4)
        .rotation3DEffect(
            .degrees(flipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if (!isEditMode) {
                        offset = gesture.translation
                        onDrag?(
                            min(
                                max(offset.width, -minSwipe),
                                minSwipe
                            ) / minSwipe
                        )
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        if abs(offset.width) > minSwipe {
                            offset.width = offset.width > 0 ? screenWidth : -screenWidth
                            offset.width > 0  ? onRight?() : onLeft?()
                            generator.impactOccurred();
                        } else {
                            offset = .zero
                        }
                        onDrag?(0)
                    }
                    

                    
                }
        
        )
        .onAnimationCompleted(for: offset.width) {
            if abs(offset.width) >= screenWidth {
                offset = .zero
            }
        }
        .animation(.spring(), value: flipped)
            .onTapGesture {
                if (!isEditMode) {
                    flipped.toggle()
                    generator.impactOccurred()
                    
                }
            }
//            .onLongPressGesture(
//                minimumDuration: 0.5,
//                pressing: { pressing in
//                    pressCount += 1
//                    isPressing = pressing
//                    let pressCountStamp = pressCount
//                    if (isPressing && pressCountStamp == pressCount && offset == .zero) {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            if (isPressing && pressCountStamp == pressCount && offset == .zero) {
//                                generator.impactOccurred()
//                            }
//                        }
//                    }
//                },
//                perform: {
//                    
//                    generator.impactOccurred()
//                    isEditMode.toggle()
//                    
//                })
        
    }
}

#Preview {
    ZStack {
        Background()
        FlashCard(card: .constant(Card(sideA: "Qa", sideB: "Ab")), isReadable: .constant(true), isEditMode: .constant(false)).padding()
    }
    
}

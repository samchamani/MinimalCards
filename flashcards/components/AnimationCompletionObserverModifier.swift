//
//  AnimationCompletionObserverModifier.swift
//  flashcards
//
//  Created by Sam Chamani on 15.10.25.
//


import SwiftUI

struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {
    var animatableData: Value {
        didSet {
            checkIfFinished()
        }
    }

    private var targetValue: Value
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.animatableData = observedValue
        self.targetValue = observedValue
        self.completion = completion
    }

    func body(content: Content) -> some View {
        content
    }

    private func checkIfFinished() {
        if animatableData == targetValue {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

extension View {
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> some View {
        self.modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
    }
}

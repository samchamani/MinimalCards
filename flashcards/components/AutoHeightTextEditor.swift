//
//  AutoSizingTextEditor.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//


import SwiftUI

struct AutoHeightTextEditor: View {
    @Binding var text: String
    @State var maxHeight: CGFloat
    @Binding var isEditMode: Bool
    @State private var textHeight: CGFloat = 55
    @Binding var placeholder: String
    
    @FocusState private var isFocused: Bool

    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .scrollDisabled(true)
                .frame(height: textHeight)
                .padding()
                .id($isEditMode.wrappedValue)
                .disabled(!$isEditMode.wrappedValue)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
            
            if text.isEmpty {
                HStack {
                    Spacer()
                    Text(placeholder)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.top, 25)
                        .multilineTextAlignment(.center)
                    Spacer()
                }

            }
        
            // Hidden Text for measuring height
            HStack {
                Spacer()
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .lineLimit(nil)
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: TextHeightPreferenceKey.self, value: min(geo.size.height,maxHeight))
                    })
                    .padding()
                    .padding([.top],-7)
                    .disabled(!$isEditMode.wrappedValue)
                    .hidden()
                
                Spacer()
            }.padding()
        }
        .onPreferenceChange(TextHeightPreferenceKey.self) { height in
            self.textHeight = height + 20 // padding compensation
        }
        .toolbar {
            if isFocused {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                            isEditMode.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 40
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

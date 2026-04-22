//
//  StartView 2.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//


import SwiftUI

struct CardsView: View {
    @Binding var cardSet: CardSet
    
    @State var index: Int = 0
    @State var isEditMode: Bool = false
    @State var isBrowseMode: Bool = false
    @State var searchText: String = ""
    @State var rightSwipes: Int = 0
    
    var progress: Double {
            if cardSet.cards.isEmpty {
                return 0.0
            } else if isBrowseMode {
                return Double(index) / Double(cardSet.cards.count)
            } else {
                return Double(rightSwipes) / Double(cardSet.cards.count)
            }
        }
    
    var body: some View {
        
        ZStack {
            Background()
            VStack {
                Text("\(rightSwipes) / \(cardSet.cards.count)")
                Progressbar(progress: progress)
                Spacer()
                
                HStack{
                    if (isBrowseMode){
                        TextField("Search", text: $searchText)
                    }
                    Spacer()
                    Text("browse").foregroundColor(.accentColor)
                    Toggle("", isOn: $isBrowseMode)
                        .frame(width: 55)
                }
                .padding([.leading, .trailing])
                
                HStack{
                    if (isEditMode) {
                        Button(action:{
                            cardSet.cards.insert(Card(sideA: "new", sideB: ""), at: index)
                        }){
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                            Text("add card")
                        }
                    }
                    Spacer()
                    
                    Text("edit").foregroundColor(.accentColor)
                    Toggle("", isOn: $isEditMode)
                        .frame(width: 55)
                }
                .padding([.leading, .trailing, .bottom])
                
                
            }
            .padding([.top],40)
            .padding([.leading,.trailing], 10)
            .ignoresSafeArea(.keyboard)
            
            Cards(cards: $cardSet.cards, index: $index, isEditMode: $isEditMode)  .padding([.leading,.trailing], 10)
            
        }
        .navigationTitle(cardSet.name)
        Options()
        
    }
    
}

#Preview {
    NavigationStack {
        CardsView(cardSet: .constant(
            CardSet(
                name: "New Set", cards: [Card(sideA: "Question?", sideB: "Answer!")]
            )
        ))
    }
}


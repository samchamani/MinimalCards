//
//  CardOneSideList.swift
//  flashcards
//
//  Created by Sam Chamani on 24.04.26.
//

import SwiftUI

struct CardOneSideList: View {

    @Binding var cards: [Card]
    @Binding var selectedIDs: Set<UUID>

    var onChange: (() -> Void)?

    var scrollAnchor = "anchor"
    @FocusState private var activeCard: FieldFocus?
    
    @State private var search: String = ""

    private var filteredTuples: [(index: Int, card: Card)] {
        let zippedCards = Array(zip(cards.indices, cards))

        let normalizedSearch =
            search
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        return zippedCards.filter { pair in
            IsStringInCard(search: normalizedSearch, card: pair.1)
        }
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(0..<filteredTuples.count, id: \.self) {
                        index in
                        HStack {
                            Checkbox(
                                isSelected:
                                    selectedIDs.contains(
                                        filteredTuples[index].card.id
                                    ),
                                action: {
                                    if selectedIDs.contains(
                                        filteredTuples[index].card.id
                                    ) {
                                        selectedIDs.remove(
                                            filteredTuples[index].card.id
                                        )
                                    } else {
                                        selectedIDs.insert(
                                            filteredTuples[index].card.id
                                        )
                                    }
                                }
                            )
                            CardOneSide(
                                card: $cards[filteredTuples[index].index],
                                activeCard: $activeCard,
                                focusIndex: index
                            )
                        }
                        .padding([.leading, .trailing, .bottom])
                        .id(index)

                    }
                    Color.clear
                        .frame(height: 30)
                        .id(scrollAnchor)
                }
            }
            .searchable(text: $search)
            .scrollDismissesKeyboard(.interactively)
            .toolbar {

                if #available(iOS 26.0, *) {
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        search = ""
                        cards.append(Card(sideA: "", sideB: ""))
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(scrollAnchor, anchor: .bottom)
                        }
                        onChange?()
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                            .frame(width: 44, height: 44)
                            .padding(10)
                            .contentShape(Rectangle())

                    }
                }
                if let current = activeCard {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack {
                            KeyboardButton(
                                icon: "plus",
                                action: {
                                    cards.append(Card(sideA: "", sideB: ""))
                                    search = ""
                                    activeCard = .sideA(
                                        row: filteredTuples.count - 1
                                    )
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        proxy.scrollTo(
                                            scrollAnchor,
                                            anchor: .bottom
                                        )
                                    }
                                    onChange?()
                                }
                            ).padding(.leading)
                            KeyboardButton(
                                icon: "chevron.up",
                                action: {
                                    activeCard = getPreviousField(
                                        from: current
                                    )
                                    let targetRow: Int
                                    switch current {
                                    case .sideA(let row): targetRow = row
                                    case .sideB(let row): targetRow = row
                                    }
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        proxy.scrollTo(
                                            targetRow,
                                            anchor: .bottom
                                        )
                                    }
                                }
                            ).disabled(current == .sideA(row: 0))
                            KeyboardButton(
                                icon: "chevron.down",
                                action: {
                                    activeCard = getNextField(
                                        from: current,
                                        total: filteredTuples.count
                                    )
                                    let targetRow: Int
                                    switch current {
                                    case .sideA(let row): targetRow = row
                                    case .sideB(let row): targetRow = row
                                    }
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        proxy.scrollTo(
                                            targetRow,
                                            anchor: .bottom
                                        )
                                    }
                                }
                            ).disabled(
                                current == .sideB(row: filteredTuples.count - 1)
                            )
                            Spacer()
                            KeyboardButton(
                                icon: "keyboard.chevron.compact.down",
                                action: { activeCard = nil }
                            ).padding(.trailing)
                        }
                    }
                }
            }
        }
    }
}

func IsStringInCard(search: String, card: Card) -> Bool {
    return search.isEmpty
        || card.sideA
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ).lowercased()
            .contains(search)
        || card.sideB
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ).lowercased()
            .contains(search)
}

enum FieldFocus: Hashable {
    case sideA(row: Int)
    case sideB(row: Int)
}

private func getNextField(from current: FieldFocus, total: Int) -> FieldFocus? {
    switch current {
    case .sideA(let row):
        return .sideB(row: row)
    case .sideB(let row):
        if row < total - 1 {
            return .sideA(row: row + 1)
        }
        return current
    }
}

private func getPreviousField(from current: FieldFocus) -> FieldFocus? {
    switch current {
    case .sideB(let row):
        return .sideA(row: row)
    case .sideA(let row):
        if row > 0 {
            return .sideB(row: row - 1)
        }
        return current
    }
}

#Preview {
    @Previewable @State var cardSet = CardSet(
        name: "New Set",
        cards: [
            Card(sideA: "Questiossasasan?", sideB: "Answer!"),
            Card(sideA: "Questioasasassassan?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
            //            Card(sideA: "Question?", sideB: "Answer!"),
        ]
    )

    @Previewable @State var selectedIDs = Set<UUID>()

    CardOneSideList(
        cards: $cardSet.cards,
        selectedIDs: $selectedIDs
    )
}

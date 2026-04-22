//
//  Menu.swift
//  flashcards
//
//  Created by Sam Chamani on 13.10.25.
//

import SwiftUI

struct Options: View {
    
    var body: some View {
        ZStack{
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        // TODO: store csv file
                    } label: {
                        Label("Save set", systemImage: "square.and.arrow.down")
                    }
                    Button {
                        // TODO: store csv file filtered
                    } label: {
                        Label("Create set of mistakes", systemImage: "square.and.arrow.down")
                    }
                    
                    Button {
                        // TODO: restart with new changes
                    } label: {
                        Label("Restart", systemImage: "arrow.clockwise")
                    }
                    
                    Button {
                        // TODO: restart with new changes
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                    }
                    
                    Button {
                        // TODO: restart with new changes
                    } label: {
                        Label("Flip cards", systemImage: "arrow.triangle.2.circlepath")
                    }
                    
                    Button(role: .destructive) {
                        // TODO: delete current card
                    } label: {
                        Label("Delete this card", systemImage: "trash")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle") // the icon for dropdown
                        .imageScale(.large)
                }
            }
        }
    }
}

//
//  ContentView.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//


import SwiftUI

struct ExportCSVButton: View {
    @State private var showExporter = false
    @State private var fileData: Data = Data()
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Save File") {
                let csvString = "Question,Answer\nHello,World"
                fileData = csvString.data(using: .utf8) ?? Data()
                showExporter = true
            }
        }
        .fileExporter(
            isPresented: $showExporter,
            document: CSVDocument(data: fileData),
            contentType: .commaSeparatedText,
            defaultFilename: "flashcards.csv"
        ) { result in
            switch result {
            case .success:
                print("File saved!")
            case .failure(let error):
                print("Failed to save file:", error)
            }
        }
    }
}

//
//  CSVDocument.swift
//  flashcards
//
//  Created by Sam Chamani on 12.10.25.
//

import SwiftUI
import UniformTypeIdentifiers 

struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var data: Data
    
    init(data: Data = Data()) {
        self.data = data
    }
    
    init(configuration: ReadConfiguration) throws {
        self.data = configuration.file.regularFileContents ?? Data()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return .init(regularFileWithContents: data)
    }
}

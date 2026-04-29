//
//  JSONLExportDocument.swift
//  Jsonique
//
//  Created by ChatGPT on 4/28/26.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var jsonl: UTType {
        UTType(filenameExtension: "jsonl") ?? .json
    }
}

struct JSONLExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.jsonl] }

    var text: String

    init(text: String = "") {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        text = ""
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}

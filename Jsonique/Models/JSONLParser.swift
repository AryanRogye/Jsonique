//
//  JSONLParser.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import Foundation

enum JSONLParser {
    static func decode(_ text: String) throws -> [DatasetRow] {
        let decoder = JSONDecoder()

        return try text
            .split(separator: "\n")
            .map(String.init)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { line in
                let data = Data(line.utf8)

                if let row = try? decoder.decode(CompletionRow.self, from: data) {
                    return .completion(row)
                }

                if let row = try? decoder.decode(TextRow.self, from: data) {
                    return .text(row)
                }

                if let row = try? decoder.decode(ToolsRow.self, from: data) {
                    return .tools(row)
                }

                if let row = try? decoder.decode(ChatRow.self, from: data) {
                    return .chat(row)
                }

                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: [],
                        debugDescription: "Unknown JSONL row format"
                    )
                )
            }
    }
}

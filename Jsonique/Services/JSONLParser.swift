//
//  JSONLParser.swift
//  Jsonique
//
//  Created by ChatGPT on 4/28/26.
//

import Foundation

/**
 * Takes raw `.jsonl` text and turns each line into a `DatasetRow`.
 *
 * JSONL is not one big JSON object — each line is its own object,
 * so we decode line-by-line and figure out which row type it is.
 */
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

    static func encode(_ rows: [DatasetRow]) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]

        let lines = try rows.map { row in
            let data: Data

            switch row {
            case .chat(let chatRow):
                data = try encoder.encode(chatRow)
            case .tools(let toolsRow):
                data = try encoder.encode(toolsRow)
            case .completion(let completionRow):
                data = try encoder.encode(completionRow)
            case .text(let textRow):
                data = try encoder.encode(textRow)
            }

            return String(decoding: data, as: UTF8.self)
        }

        return lines.joined(separator: "\n") + "\n"
    }
}

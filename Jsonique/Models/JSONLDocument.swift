//
//  JSONLFile.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import Foundation

/**
 * Represents a full `.jsonl` document.
 *
 * JSONL is a collection of independent rows (one per line),
 * each represented here as a `DatasetRow`.
 */
struct JSONLDocument {
    var rows: [DatasetRow] = []
}

/**
 * Represents a single JSONL row.
 *
 * Each line in a `.jsonl` file is one independent dataset entry,
 * which can be one of the supported formats: chat, tools,
 * completion, or raw text.
 */
enum DatasetRow {
    case chat(ChatRow)
    case tools(ToolsRow)
    case completion(CompletionRow)
    case text(TextRow)
}
/**
 * UI-facing representation of supported dataset row types.
 *
 * Used to drive row creation in the view layer and provide
 * empty starter rows for each format.
 */
enum DatasetParsable: String, CaseIterable {
    case chat = "Chat"
    case tools = "Tools"
    case completion = "Completion"
    case text = "Text"
    
    /**
     * Used while adding a new row
     * we can use this to append a blank row
     */
    var emptyRow: DatasetRow {
        switch self {
        case .chat:
            DatasetRow.chat(.init(messages: []))
        case .tools:
            DatasetRow.tools(.init(messages: [], tools: []))
        case .completion:
            DatasetRow.completion(.init(prompt: "", completion: ""))
        case .text:
            DatasetRow.text(.init(text: ""))
        }
    }
}

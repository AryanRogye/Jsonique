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

// MARK: - Types
enum ToolType: String, Codable {
    case function
}
enum JSONSchemaType: String, Codable {
    case string
    case number
    case integer
    case boolean
    case array
    case object
}

// MARK: - Rows
struct ChatRow: Codable {
    var messages: [Message]
}

struct ToolsRow: Codable {
    var messages: [Message]
    var tools: [ToolDefinition]
}

struct CompletionRow: Codable {
    var prompt: String
    var completion: String
}

struct TextRow: Codable {
    var text: String
}


// MARK: - Tools
struct ToolDefinition: Codable {
    var type: ToolType
    var function: ToolDefinitionFunction
}

struct ToolDefinitionFunction: Codable {
    var name: String
    var description: String
    var parameters: Parameters
}

struct Parameters: Codable {
    var type: JSONSchemaType
    var properties:  [String: ToolProperty]
    var required: [String]
}

struct ToolProperty: Codable {
    var type: JSONSchemaType
    var description: String?
    var enumValues: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case description
        case enumValues = "enum"
    }
}

// MARK: - Message
struct Message: Codable {
    var role: Role
    var content: String?
    var toolCalls: [ToolCall]?
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case toolCalls = "tool_calls"
    }
}


struct ToolCall: Codable {
    var id: String
    var type: ToolType
    var function: ToolCallFunction
}

struct ToolCallFunction: Codable {
    var name: String
    var arguments: String
}

enum Role: String, Codable {
    case system
    case user
    case assistant
    case tool
}

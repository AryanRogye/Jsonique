//
//  Message.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

/**
 * Represents a single message in a chat-style dataset row.
 *
 * A message can either:
 * - contain `content` (normal chat)
 * - contain `toolCalls` (assistant requesting tool execution)
 */
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

/**
 * Represents a tool call emitted by the assistant.
 *
 * Matches the OpenAI-style function calling format where the model
 * requests a function to be executed with JSON string arguments.
 */
struct ToolCall: Codable {
    var id: String
    var type: ToolType
    var function: ToolCallFunction
}

/**
 * The function payload inside a tool call.
 *
 * Note: `arguments` is a JSON-encoded string, not a dictionary.
 * It must be parsed separately if structured access is needed.
 */
struct ToolCallFunction: Codable {
    var name: String
    var arguments: String
}

/**
 * The role of a message in a chat conversation.
 *
 * - system: sets behavior/instructions
 * - user: input from the user
 * - assistant: model response (text or tool calls)
 *- tool: response from a tool (optional, less common in datasets)
 */
enum Role: String, Codable {
    case system
    case user
    case assistant
    case tool
}

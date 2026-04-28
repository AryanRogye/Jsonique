//
//  Rows.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//
//  This file contains all rows that can show up
//  in a jsonl file
//
//  NOTE:
//  These examples are intentionally 1:1 with MLX JSONL formats
//  so future changes don’t accidentally break compatibility.
//

// MARK: - Chat Row
/**
 * ChatRow Example:
 *
 * {
 *   "messages":[
 *       {
 *           "role":"user",
 *           "content":"Hello"
 *       },
 *       {
 *           "role":"assistant",
 *           "content":"Hi."
 *       }
 *   ]
 * }
 */
struct ChatRow: Codable {
    var messages: [Message]
}

// MARK: - ToolsRow
/**
 * ToolsRow Example:
 *
 * {
 *   "messages":[
 *       {
 *           "role":"user",
 *           "content":"What is the weather in San Francisco?"
 *       },
 *       {
 *           "role":"assistant",
 *           "tool_calls":[
 *               {
 *                   "id":"call_id",
 *                   "type":"function",
 *                   "function":{
 *                       "name":"get_current_weather",
 *                       "arguments":"{\"location\":\"San Francisco, USA\",\"format\":\"celsius\"}"
 *                   }
 *               }
 *           ]
 *       }
 *   ],
 *   "tools":[
 *       {
 *           "type":"function",
 *           "function":{
 *               "name":"get_current_weather",
 *               "description":"Get the current weather",
 *               "parameters":{
 *                   "type":"object",
 *                   "properties":{
 *                       "location":{
 *                           "type":"string",
 *                           "description":"The city and country."
 *                       },
 *                       "format":{
 *                           "type":"string",
 *                           "enum":[
 *                               "celsius",
 *                               "fahrenheit"
 *                           ]
 *                       }
 *                   },
 *                   "required":[
 *                       "location",
 *                       "format"
 *                   ]
 *               }
 *           }
 *       }
 *   ]
 * }
 */
struct ToolsRow: Codable {
    var messages: [Message]
    var tools: [ToolDefinition]
}

// MARK: - CompletionRow
/**
 * CompletionRow Example:
 * {
 *      "prompt":"Question: What is JSONL?",
 *      "completion":"Answer: JSONL is newline-delimited JSON."
 * }
 */
struct CompletionRow: Codable {
    var prompt: String
    var completion: String
}

// MARK: - TextRow
/**
 * TextRow Example:
 * {
 *      "text":"Write your dataset text here."
 * }
 */
struct TextRow: Codable {
    var text: String
}

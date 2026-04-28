//
//  Types.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

/**
 * The type of tool definition.
 *
 * Currently only supports `function`, but structured
 * this way to allow future expansion.
 */
enum ToolType: String, Codable {
    case function
}

/**
 * Represents JSON Schema value types used in tool parameters.
 *
 * Matches the standard JSON Schema types (e.g. string, number, object)
 * used when defining tool input structures.
 */
enum JSONSchemaType: String, Codable {
    case string
    case number
    case integer
    case boolean
    case array
    case object
}

//
//  Tools.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

/**
 * Defines a tool available to the model.
 *
 * This follows the OpenAI/MLX tool specification where a tool is
 * typically a function with a name, description, and input schema.
 */
struct ToolDefinition: Codable {
    var type: ToolType
    var function: ToolDefinitionFunction
}

/**
 * The function signature exposed to the model.
 *
 * Includes:
 * - name: function identifier
 * - description: natural language explanation for the model
 * - parameters: JSON Schema describing expected inputs
 */
struct ToolDefinitionFunction: Codable {
    var name: String
    var description: String
    var parameters: Parameters
}

/**
 * JSON Schema definition for a tool's input parameters.
 *
 * - type: always "object"
 * - properties: dictionary of parameter definitions
 * - required: list of required parameter keys
 */
struct Parameters: Codable {
    var type: JSONSchemaType
    var properties:  [String: ToolProperty]
    var required: [String]
}

/**
 * Defines a single parameter within a tool's input schema.
 *
 * - type: JSON value type (string, number, etc.)
 * - description: optional explanation for the model
 * - enumValues: optional list of allowed values
 */
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

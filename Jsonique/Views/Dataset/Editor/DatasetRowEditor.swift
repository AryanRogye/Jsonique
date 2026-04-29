//
//  DatasetRowEditor.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct DatasetRowEditor: View {
    @Binding var row: DatasetRow
    
    var body: some View {
        switch row {
        case .text:
            TextRowEditor(row: textBinding)
            
        case .completion:
            CompletionRowEditor(row: completionBinding)
            
        case .chat:
            ChatRowEditor(row: chatBinding)
            
        case .tools:
            ToolRowEditor(row: toolBinding)
        }
    }

    private var toolBinding: Binding<ToolsRow> {
        Binding<ToolsRow>(
            get: { 
                if case .tools(let value) = row { return value }
                return ToolsRow(messages: [], tools: [])
            },
            set: { row = .tools($0) }
        )
    }

    private var chatBinding: Binding<ChatRow> {
        Binding<ChatRow>(
            get: { 
                if case .chat(let value) = row { return value }
                return ChatRow(messages: [])
            },
            set: { row = .chat($0) }
        )
    }
    
    private var textBinding: Binding<TextRow> {
        Binding<TextRow>(
            get: {
                if case .text(let value) = row { return value }
                return TextRow(text: "")
            },
            set: { row = .text($0) }
        )
    }
    
    private var completionBinding: Binding<CompletionRow> {
        Binding<CompletionRow>(
            get: {
                if case .completion(let value) = row {
                    return value
                }
                return CompletionRow(prompt: "", completion: "")
            },
            set: { row = .completion($0) }
        )
    }
}

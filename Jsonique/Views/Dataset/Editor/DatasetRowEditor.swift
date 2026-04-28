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
            Text("Completion Editor Goes Here")
            
        case .chat:
            Text("Chat editor goes here")
            
        case .tools:
            Text("Tools editor goes here")
        }
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

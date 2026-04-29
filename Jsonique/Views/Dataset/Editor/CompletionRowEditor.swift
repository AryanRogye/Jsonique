//
//  CompletionRowEditor.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct CompletionRowEditor: View {
    
    @Binding var row: CompletionRow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            
            editorSection(
                title: "Prompt",
                subtitle: "The input the model receives.",
                text: $row.prompt,
                placeholder: "What is the capital of France?"
            )
            
            editorSection(
                title: "Completion",
                subtitle: "The response the model should learn to produce.",
                text: $row.completion,
                placeholder: "Paris."
            )
            
            Spacer()
        }
        .padding(32)
        .frame(maxWidth: 900, maxHeight: .infinity, alignment: .topLeading)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Completion Row")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Train the model with a simple prompt → completion pair.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
    
    private func editorSection(
        title: String,
        subtitle: String,
        text: Binding<String>,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            CustomTextFeild(placeholder, text: text)
                .frame(minHeight: 44)
        }
    }
}

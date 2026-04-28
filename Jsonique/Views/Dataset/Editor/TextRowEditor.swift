//
//  DatasetEditorView.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI
import TextEditor

struct TextRowEditor: View {
    @Binding var row: TextRow
    
    @State private var editorCommands: EditorCommands?
    @State private var magnification: CGFloat = 1
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Text Row")
                    .font(.title.bold())
                Button("Toggle Wrap") { editorCommands?.toggleWrap() }
                    .keyboardShortcut("w", modifiers: .command)
                Button("Increase Font") { editorCommands?.increaseFontOrZoomIn() }
                    .keyboardShortcut("+", modifiers: .command)
                Button("Decrease Font") { editorCommands?.decreaseFontOrZoomOut() }
                    .keyboardShortcut("-", modifiers: .command)
            }
            
            
            ComfyTextEditor(
                text: $row.text,
                magnification: $magnification,
                noWrap: false,
                showScrollbar: .constant(false),
                isInVimMode: .constant(true),
                onReady: { editorCommands in
                    DispatchQueue.main.async {
                        self.editorCommands = editorCommands
                    }
                },
            )
        }
        .padding()
    }
}

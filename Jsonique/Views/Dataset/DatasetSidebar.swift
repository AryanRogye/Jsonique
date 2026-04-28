//
//  DatasetSidebar.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct DatasetSidebar: View {
    let row: DatasetRow
    
    var body: some View {
        HStack {
            badge
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
    
    private var title: String {
        switch row {
        case .chat: "Chat"
        case .tools: "Tools"
        case .completion: "Completion"
        case .text: "Text"
        }
    }
    
    private var summary: String {
        switch row {
        case .text(let row):
            row.text
        case .completion(let row):
            row.prompt
        case .chat(let row):
            "\(row.messages.count) messages"
        case .tools(let row):
            "\(row.messages.count) messages • \(row.tools.count) tools"
        }
    }
    
    private var badge: some View {
        Text(title.prefix(1))
            .font(.caption.bold())
            .frame(width: 28, height: 28)
            .background(.quaternary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

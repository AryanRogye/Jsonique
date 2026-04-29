//
//  ChatRowEditor.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct ChatRowEditor: View {
    @Binding var row: ChatRow

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(row.messages.indices, id: \.self) { index in
                    MessageEditorRow(
                        message: $row.messages[index],
                        onDelete: { row.messages.remove(at: index) }
                    )
                }

                AddMessageButton {
                    row.messages.append(Message(role: .user, content: ""))
                }
            }
            .padding()
        }
    }
}

// MARK: - MessageEditorRow

struct MessageEditorRow: View {
    @Binding var message: Message
    var onDelete: () -> Void

    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                RolePicker(role: $message.role)
                Spacer()
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(roleHeaderColor(message.role).opacity(0.08))

            if isExpanded {
                Divider()

                if message.role == .assistant, let toolCalls = message.toolCalls, !toolCalls.isEmpty {
                    ToolCallsSection(toolCalls: Binding(
                        get: { message.toolCalls ?? [] },
                        set: { message.toolCalls = $0 }
                    ))
                } else {
                    // Content editor
                    TextEditor(text: Binding(
                        get: { message.content ?? "" },
                        set: { message.content = $0.isEmpty ? nil : $0 }
                    ))
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 80)
                    .padding(8)
                    .scrollContentBackground(.hidden)
                }

                // Tool calls toggle (assistant only)
                if message.role == .assistant {
                    Divider()
                    HStack {
                        Toggle("Has tool calls", isOn: Binding(
                            get: { message.toolCalls != nil },
                            set: { hasTools in
                                if hasTools {
                                    message.toolCalls = [ToolCall(
                                        id: UUID().uuidString,
                                        type: .function,
                                        function: ToolCallFunction(name: "", arguments: "{}")
                                    )]
                                    message.content = nil
                                } else {
                                    message.toolCalls = nil
                                }
                            }
                        ))
                        .toggleStyle(.switch)
                        .controlSize(.small)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.windowBackgroundColor))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(roleHeaderColor(message.role).opacity(0.3), lineWidth: 1)
        }
    }

    /// MARK: - Role → accent color
    func roleHeaderColor(_ role: Role) -> Color {
        switch role {
        case .system:    return .purple
        case .user:      return .blue
        case .assistant: return .green
        case .tool:      return .orange
        }
    }
}

// MARK: - RolePicker

struct RolePicker: View {
    @Binding var role: Role

    var body: some View {
        Picker("", selection: $role) {
            ForEach([Role.system, .user, .assistant, .tool], id: \.self) { r in
                Text(r.rawValue.capitalized).tag(r)
            }
        }
        .pickerStyle(.menu)
        .labelsHidden()
        .fixedSize()
    }
}

// MARK: - ToolCallsSection

struct ToolCallsSection: View {
    @Binding var toolCalls: [ToolCall]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(toolCalls.indices, id: \.self) { i in
                ToolCallEditor(toolCall: $toolCalls[i]) {
                    toolCalls.remove(at: i)
                }
            }

            Button {
                toolCalls.append(ToolCall(
                    id: UUID().uuidString,
                    type: .function,
                    function: ToolCallFunction(name: "", arguments: "{}")
                ))
            } label: {
                Label("Add Tool Call", systemImage: "plus")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
    }
}

// MARK: - ToolCallEditor

struct ToolCallEditor: View {
    @Binding var toolCall: ToolCall
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Tool Call")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.red.opacity(0.7))
                }
                .buttonStyle(.plain)
            }

            LabeledField("ID") {
                TextField("call_abc123", text: $toolCall.id)
            }
            LabeledField("Function name") {
                TextField("get_weather", text: $toolCall.function.name)
            }
            LabeledField("Arguments (JSON)") {
                TextEditor(text: $toolCall.function.arguments)
                    .font(.system(.caption, design: .monospaced))
                    .frame(minHeight: 56)
                    .scrollContentBackground(.hidden)
            }
        }
        .padding(10)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - LabeledField

struct LabeledField<Content: View>: View {
    let label: String
    @ViewBuilder var content: () -> Content

    init(_ label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.tertiary)
            content()
        }
    }
}

// MARK: - AddMessageButton

struct AddMessageButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Message")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.bordered)
        .controlSize(.regular)
    }
}

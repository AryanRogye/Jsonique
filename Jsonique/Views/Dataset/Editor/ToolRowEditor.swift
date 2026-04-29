//
//  ToolRowEditor.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct ToolRowEditor: View {
    @Binding var row: ToolsRow

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // MARK: Tools Section
                SectionHeader(title: "Tools", systemImage: "wrench.and.screwdriver") {
                    row.tools.append(ToolDefinition(
                        type: .function,
                        function: ToolDefinitionFunction(
                            name: "",
                            description: "",
                            parameters: Parameters(
                                type: .object,
                                properties: [:],
                                required: []
                            )
                        )
                    ))
                }

                VStack(spacing: 10) {
                    ForEach(row.tools.indices, id: \.self) { index in
                        ToolDefinitionEditor(
                            tool: $row.tools[index],
                            onDelete: { row.tools.remove(at: index) }
                        )
                    }
                    if row.tools.isEmpty {
                        EmptyStateLabel(text: "No tools defined")
                    }
                }

                Divider()

                // MARK: Messages Section
                SectionHeader(title: "Messages", systemImage: "bubble.left.and.bubble.right") {
                    row.messages.append(Message(role: .user, content: ""))
                }

                VStack(spacing: 12) {
                    ForEach(row.messages.indices, id: \.self) { index in
                        MessageEditorRow(
                            message: $row.messages[index],
                            onDelete: { row.messages.remove(at: index) }
                        )
                    }
                    if row.messages.isEmpty {
                        EmptyStateLabel(text: "No messages")
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - ToolDefinitionEditor

struct ToolDefinitionEditor: View {
    @Binding var tool: ToolDefinition
    var onDelete: () -> Void

    @State private var isExpanded = true
    @State private var newParamKey = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            HStack {
                Image(systemName: "function")
                    .foregroundStyle(.orange)
                    .font(.caption)
                Text(tool.function.name.isEmpty ? "unnamed function" : tool.function.name)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(tool.function.name.isEmpty ? .tertiary : .primary)
                Spacer()
                Button { withAnimation { isExpanded.toggle() } } label: {
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
            .background(Color.orange.opacity(0.07))

            if isExpanded {
                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    LabeledField("Function name") {
                        TextField("get_weather", text: $tool.function.name)
                            .font(.system(.body, design: .monospaced))
                    }
                    LabeledField("Description") {
                        TextEditor(text: $tool.function.description)
                            .font(.body)
                            .frame(minHeight: 56)
                            .scrollContentBackground(.hidden)
                    }

                    Divider()

                    // Parameters
                    HStack {
                        Text("Parameters")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }

                    if tool.function.parameters.properties.isEmpty {
                        EmptyStateLabel(text: "No parameters")
                    } else {
                        VStack(spacing: 8) {
                            ForEach(Array(tool.function.parameters.properties.keys.sorted()), id: \.self) { key in
                                ToolPropertyEditor(
                                    paramKey: key,
                                    property: Binding(
                                        get: { tool.function.parameters.properties[key]! },
                                        set: { tool.function.parameters.properties[key] = $0 }
                                    ),
                                    isRequired: Binding(
                                        get: { tool.function.parameters.required.contains(key) },
                                        set: { isReq in
                                            if isReq {
                                                if !tool.function.parameters.required.contains(key) {
                                                    tool.function.parameters.required.append(key)
                                                }
                                            } else {
                                                tool.function.parameters.required.removeAll { $0 == key }
                                            }
                                        }
                                    ),
                                    onRename: { newKey in
                                        guard newKey != key, !newKey.isEmpty else { return }
                                        let val = tool.function.parameters.properties.removeValue(forKey: key)!
                                        tool.function.parameters.properties[newKey] = val
                                        if let i = tool.function.parameters.required.firstIndex(of: key) {
                                            tool.function.parameters.required[i] = newKey
                                        }
                                    },
                                    onDelete: {
                                        tool.function.parameters.properties.removeValue(forKey: key)
                                        tool.function.parameters.required.removeAll { $0 == key }
                                    }
                                )
                            }
                        }
                    }

                    // Add parameter row
                    HStack(spacing: 6) {
                        TextField("param_name", text: $newParamKey)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: 160)
                        Button {
                            let key = newParamKey.trimmingCharacters(in: .whitespaces)
                            guard !key.isEmpty, tool.function.parameters.properties[key] == nil else { return }
                            tool.function.parameters.properties[key] = ToolProperty(type: .string, description: nil, enumValues: nil)
                            newParamKey = ""
                        } label: {
                            Label("Add param", systemImage: "plus")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                .padding(12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
        }
    }
}

// MARK: - ToolPropertyEditor

struct ToolPropertyEditor: View {
    let paramKey: String
    @Binding var property: ToolProperty
    @Binding var isRequired: Bool
    var onRename: (String) -> Void
    var onDelete: () -> Void

    @State private var editingKey: String = ""
    @State private var isEditingKey = false
    @State private var newEnumValue = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                // Key name (tappable to rename)
                if isEditingKey {
                    TextField("key", text: $editingKey, onCommit: {
                        onRename(editingKey)
                        isEditingKey = false
                    })
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: 140)
                } else {
                    Text(paramKey)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(.primary)
                        .onTapGesture {
                            editingKey = paramKey
                            isEditingKey = true
                        }
                }

                // Type picker
                Picker("", selection: $property.type) {
                    ForEach(JSONSchemaType.allCases, id: \.self) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .controlSize(.small)
                .fixedSize()

                Spacer()

                // Required toggle
                Toggle("req", isOn: $isRequired)
                    .toggleStyle(.checkbox)
                    .controlSize(.small)

                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.red.opacity(0.7))
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }

            // Description
            TextField("Description", text: Binding(
                get: { property.description ?? "" },
                set: { property.description = $0.isEmpty ? nil : $0 }
            ))
            .font(.caption)
            .foregroundStyle(.secondary)

            // Enum values (only if type is string)
            if property.type == .string {
                VStack(alignment: .leading, spacing: 4) {
                    if let enums = property.enumValues, !enums.isEmpty {
                        FlowLayout(spacing: 4) {
                            ForEach(enums, id: \.self) { val in
                                HStack(spacing: 3) {
                                    Text(val)
                                        .font(.caption2)
                                    Button {
                                        property.enumValues?.removeAll { $0 == val }
                                        if property.enumValues?.isEmpty == true { property.enumValues = nil }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 8))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.accentColor.opacity(0.1))
                                .clipShape(Capsule())
                            }
                        }
                    }
                    HStack(spacing: 4) {
                        TextField("Add enum value", text: $newEnumValue)
                            .font(.caption)
                            .frame(maxWidth: 160)
                        Button {
                            let v = newEnumValue.trimmingCharacters(in: .whitespaces)
                            guard !v.isEmpty else { return }
                            if property.enumValues == nil { property.enumValues = [] }
                            if !property.enumValues!.contains(v) { property.enumValues!.append(v) }
                            newEnumValue = ""
                        } label: {
                            Image(systemName: "return")
                                .font(.caption)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(8)
        .background(Color(.controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

// MARK: - SectionHeader

struct SectionHeader: View {
    let title: String
    let systemImage: String
    var onAdd: () -> Void

    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.headline)
            Spacer()
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(Color.accentColor)
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - EmptyStateLabel

struct EmptyStateLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.tertiary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}

// MARK: - FlowLayout (for enum chips)

struct FlowLayout: Layout {
    var spacing: CGFloat = 4

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(subviews: subviews, in: proposal.replacingUnspecifiedDimensions()).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(subviews: subviews, in: bounds.size)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: ProposedViewSize(frame.size))
        }
    }

    private func layout(subviews: Subviews, in size: CGSize) -> (size: CGSize, frames: [CGRect]) {
        var frames: [CGRect] = []
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for subview in subviews {
            let sz = subview.sizeThatFits(.unspecified)
            if x + sz.width > size.width && x > 0 {
                x = 0; y += rowHeight + spacing; rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: sz))
            x += sz.width + spacing
            rowHeight = max(rowHeight, sz.height)
        }
        return (CGSize(width: size.width, height: y + rowHeight), frames)
    }
}

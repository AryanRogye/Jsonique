//
//  JsoniqueContent.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct JsoniqueContent: View {
    @Bindable var vm: JsoniqueViewModel
    @State private var showAddNewRow = false
    
    var body: some View {
        HSplitView {
            List(selection: $vm.selectedRowIndex) {
                if !vm.document.rows.isEmpty {
                    Button("Add New Row") { showAddNewRow = true }
                }
                ForEach(vm.document.rows.indices, id: \.self) { index in
                    DatasetSidebar(row: vm.document.rows[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .tag(index as Int?)
                }
            }
            .frame(minWidth: 300)
            .frame(maxHeight: .infinity)
            
            
            if let index = vm.selectedRowIndex {
                DatasetRowEditor(row: $vm.document.rows[index])
                    .id(index)
                    .frame(minWidth: 500)
                    .frame(maxHeight: .infinity)
            } else {
                Text("Select a row")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showAddNewRow) {
            sheet
        }
    }
    
    private var sheet: some View {
        VStack(spacing: 12) {
            Text("Add Row")
                .font(.title2)
                .fontWeight(.semibold)
            
            ForEach(DatasetParsable.allCases, id: \.self) { dataset in
                Button(dataset.rawValue) {
                    vm.addRow(dataset)
                    showAddNewRow = false
                }
                .frame(maxWidth: .infinity)
            }
            
            Button("Cancel") {
                showAddNewRow = false
            }
            .foregroundStyle(.red)
        }
        .padding()
        .presentationDetents([.medium])
    }
}

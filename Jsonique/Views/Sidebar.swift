//
//  Sidebar.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI

struct Sidebar: View {
    
    @Bindable var vm: JsoniqueViewModel
    var onAddFiles: () -> Void
    
    var body: some View {
        List(selection: $vm.selectedFileURL) {
            ForEach(vm.urls, id: \.self) { url in
                Text(url.lastPathComponent)
                    .tag(url)
            }
            .onDelete(perform: vm.removeUrl)
        }
        .navigationTitle("Datasets")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: onAddFiles) {
                    Label("Add Files", systemImage: "plus")
                }
            }
        }
    }
}

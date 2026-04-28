//
//  ContentView.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var vm = JsoniqueViewModel()
    
    @State private var isShowingSheet = false
    @State private var isShowingImporter = false
    
    var body: some View {
        NavigationSplitView {
            Sidebar(vm: vm) { isShowingSheet = true }
        } detail: {
            // MARK: - Detail (The Editor)
            JsoniqueContent(vm: vm)
        }
        .sheet(isPresented: $isShowingSheet) {
            addSheet
        }
        .fileImporter(
            isPresented: $isShowingImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true,
            onCompletion: { file in
                vm.handleFile(file)
            }
        )
        .alert(isPresented: $vm.showError) {
            Alert(
                title: Text("Error"),
                message: Text(vm.error ?? "Unkwon Error")
            )
        }
    }
    
    @ViewBuilder
    private var addSheet: some View {
        VStack(spacing: 20) {
            Text("Add Dataset")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                Button {
                    isShowingSheet = false
                    isShowingImporter = true
                } label: {
                    Label("Import Files", systemImage: "tray.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    vm.createNewFile()
                    isShowingSheet = false
                } label: {
                    Label("Create New File", systemImage: "doc.badge.plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Divider()
            
            Button("Cancel") {
                isShowingSheet = false
            }
            .foregroundStyle(.red)
        }
        .padding()
        .presentationDetents([.medium])
    }
}

#Preview {
    ContentView()
}

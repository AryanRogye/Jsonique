//
//  JsoniqueViewModel.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class JsoniqueViewModel {
    

    var urls: [URL] = []
    
    /// Which file is currently selected in the sidebar
    var selectedFileURL: URL?
    
    /// Selected Row Index In the URL for the document
    var selectedRowIndex: Int?
    
    var document = JSONLDocument()
    
    private(set) var error: String?
    var showError = false
    
    public init() {
        
        startObservations()
    }
    
    /**
     * Function Adds a New Empty Row
     */
    func addRow(_ type: DatasetParsable) {
        document.rows.append(type.emptyRow)
        selectedRowIndex = document.rows.indices.last
    }
    
    /**
     * Starts observing `selectedFileURL`.
     *
     * Each sidebar URL maps to its own `JSONLDocument`, so whenever the
     * selected file changes, we load that file's document into the editor.
     *
     * This lives in the view model instead of `onChange(of:)` so the observation
     * can outlive any specific SwiftUI view and can also respond to programmatic
     * selection changes.
     */
    public func startObservations() {
        withObservationTracking {
            _ = selectedFileURL
        } onChange: { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                if let url = self.selectedFileURL {
                    /// this is important because this was causing a crash
                    self.selectedRowIndex = 0
                    self.loadDocument(from: url)
                }
                self.startObservations()
            }
        }
        
    }

    /**
     * This is given to us by `.fileImporter()`
     * We just add it to our list of URLS
     */
    public func handleFile(_ file: Result<[URL], Error>) {
        switch file {
        case .success(let success):
            do {
                urls.append(contentsOf: try FileImportService.createWorkingCopies(from: success))
            } catch {
                self.error = error.localizedDescription
                showError = true
            }
        case .failure(let failure):
            self.error = failure.localizedDescription
            showError = true
        }
    }
    
    /**
     * This is used when we add a new file from the sheet
     * we need to give it something blank
     * this represents a new jsonl file
     */
    public func createNewFile() {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("\(UUID().uuidString).jsonl")
        
        let initialContent = #"{"text":""}"#.data(using: .utf8)!
        
        do {
            try initialContent.write(to: fileURL)
            urls.append(fileURL)
            selectedFileURL = fileURL
            loadDocument(from: fileURL)
        } catch {
            print("Failed to create file:", error)
        }
    }
    
    /**
     * Function Loads the document fro mthe URL
     */
    public func loadDocument(from url: URL) {
        do {
            let text = try String(contentsOf: url, encoding: .utf8)
            let rows = try JSONLParser.decode(text)
            document = JSONLDocument(rows: rows)
            selectedRowIndex = nil
        } catch {
            print("Failed to load:", error)
        }
    }

    public func showError(_ error: Error) {
        self.error = error.localizedDescription
        showError = true
    }
    
    /**
     * Function removes url at the index and removes from file manager since
     * this is a copy anyways
     */
    public func removeUrl(_ index: IndexSet) {
        for i in index {
            let url = urls[i]
            try? FileManager.default.removeItem(at: url)
        }
        urls.remove(atOffsets: index)
    }
}

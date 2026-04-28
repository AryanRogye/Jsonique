//
//  FileImportService.swift
//  Jsonique
//
//  Created by Aryan Rogye on 4/28/26.
//

import Foundation

enum FileImportService {
    
    /// Copies selected files to a temporary directory and returns the new working URLs.
    static func createWorkingCopies(from urls: [URL]) throws -> [URL] {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        var workingURLs: [URL] = []
        
        for url in urls {
            // REQUIRED: You must request access to files coming from fileImporter
            let hasAccess = url.startAccessingSecurityScopedResource()
            defer {
                if hasAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            // Create a unique name so imports with the same name don't clash
            let uniqueName = "\(UUID().uuidString)-\(url.lastPathComponent)"
            let destinationURL = tempDir.appendingPathComponent(uniqueName)
            
            // Copy to temp space
            try fileManager.copyItem(at: url, to: destinationURL)
            workingURLs.append(destinationURL)
        }
        
        return workingURLs
    }
}

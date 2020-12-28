//
//  JVFileManager.swift.swift
//  
//
//  Created by Jan Verrept on 26/12/2019.
//
import Foundation
import os.log


public extension FileManager{
    
    func checkForDirectory(_ directoryURL:URL, createIfNeeded:Bool = false){
        Debugger.shared.log(debugLevel: .Message, "Checking for folder at \(directoryURL.path)")
        var isFolder:ObjCBool = false
        let supportFolderExists = FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isFolder) && isFolder.boolValue
        if !supportFolderExists && createIfNeeded{
            do {
                try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                Debugger.shared.log(debugLevel: .Succes, "Created folder")
            } catch {
                //TODO: - finish errorHandling
            }
        }
    }
    
    func rename(_ originalURL:URL, to newURL:URL){
        let originalName = originalURL.lastPathComponent
        let newName = newURL.lastPathComponent
        do {
            if fileExists(atPath: newURL.path){
                try removeItem(at:newURL)
            }
            try moveItem(at: originalURL, to: newURL)
        }
        catch let error as NSError {
            Debugger.shared.log(debugLevel: .Native(logType:.error), "Could not rename file from \(originalName) to \(newName):\n\(error)")
        }
        
    }
    
    
    
}

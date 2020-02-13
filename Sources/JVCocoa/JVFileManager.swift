//
//  JVFileManager.swift.swift
//  
//
//  Created by Jan Verrept on 26/12/2019.
//
import Foundation

public extension FileManager{
    
    func checkForDirectory(_ directoryURL:URL, createIfNeeded:Bool = false){
        JVDebugger.shared.log(debugLevel: .Message, "Checking for folder at \(directoryURL.path)")
        var isFolder:ObjCBool = false
        let supportFolderExists = FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isFolder) && isFolder.boolValue
        if !supportFolderExists && createIfNeeded{
            do {
                try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                JVDebugger.shared.log(debugLevel: .Succes, "Created folder")
            } catch {
                //TODO: - finish errorHandling
            }
        }
    }
    

    
}

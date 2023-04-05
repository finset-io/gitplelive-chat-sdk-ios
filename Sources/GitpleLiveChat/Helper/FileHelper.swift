//
//  FileHelper.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

class FileHelper: NSObject {
    
    static func getPathUrl() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static func getPath() -> String {
        if let documentDirectoryUrl = getPathUrl() {
            return documentDirectoryUrl.path
        }
        return ""
    }
    
    static func getFileUrl(_ fileName: String) -> URL? {
        if let documentDirectoryUrl = getPathUrl() {
            return documentDirectoryUrl.appendingPathComponent(fileName)
        }
        return nil
    }
    
    static func getFilePath(_ fileName: String) -> String {
        if let fileUrl = getFileUrl(fileName) {
            return fileUrl.path
        }
        return ""
    }
    
    static func fileExists(fileName: String) -> Bool {
        if fileName.isEmpty { return false }

        return FileManager.default.fileExists(atPath: getFilePath(fileName))
    }
    
    static func appendStringFile(fileName: String, text: String) {
        if !fileExists(fileName: fileName) { return }
        
        guard let fileUrl = getFileUrl(fileName) else { return }

        do {
            let fileHandle = try FileHandle(forWritingTo: fileUrl)
            fileHandle.seekToEndOfFile()
            fileHandle.write(text.utf8)
            fileHandle.closeFile()
            print("[FileHelper] append(\(fileName)) -> \(text.count)")
        }
        catch {
            print("[FileHelper] Can't open fileHandle")
        }
    }
    
    static func saveFile(fileName: String, data: Data) -> URL? {
        guard let fileUrl = getFileUrl(fileName) else { return nil }
        
        // Save data into file
        do {
            try data.write(to: fileUrl, options: [])
            print("[FileHelper] save(\(fileName))")
            return fileUrl
        } catch {
            print("[FileHelper]", error)
            return nil
        }
    }
    
    static func saveStringFile(fileName: String, text: String) {
        guard let fileUrl = getFileUrl(fileName) else { return }
        
        // Save text into file
        do {
            try text.utf8.write(to: fileUrl, options: [])
            print("[FileHelper] save(\(fileName)) -> \(text.count)")
        } catch {
            print("[FileHelper]", error)
        }
    }
    
    static func getStringFile(fileName: String) -> String {
        if !fileExists(fileName: fileName) { return "" }
        
        var url = getFileUrl(fileName)
        
        if fileName.starts(with: "file://") {
            url = URL(string: fileName)
        }
        
        guard let fileUrl = url else { return "" }
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            let text = data.string
            print("[FileHelper] read(\(fileName)) -> \(text.count)")
            return text
        } catch {
            print("[FileHelper]", error)
        }
        return ""
    }
    
    static func saveToJsonFile(fileName: String, dict: NSDictionary) {
        guard let fileUrl = getFileUrl(fileName) else { return }
        
        // Transform array into data and save it into file
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            try data.write(to: fileUrl, options: [])
            let count = (dict["list"] as? NSArray)?.count ?? 0
            print("[FileHelper] save(\(fileName))" + (count == 0 ? "" : " -> \(count)"))
        } catch {
            print("[FileHelper]", error)
        }
    }
    
    static func getFromJsonFile(fileName: String) -> NSDictionary? {
        if !fileExists(fileName: fileName) { return nil }
        
        guard let fileUrl = getFileUrl(fileName) else { return nil }
        
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return [:] }
            let count = (dict["list"] as? NSArray)?.count ?? 0
            print("[FileHelper] read(\(fileName))" + (count == 0 ? "" : " -> \(count)"))
            return dict
        } catch {
            print("[FileHelper]", error)
        }
        return nil
    }
    
    static func saveToListFile(fileName: String, array: NSArray) {
        saveToJsonFile(fileName: fileName, dict: ["list" : array])
    }
    
    static func getFromListFile(fileName: String) -> NSArray? {
        if let dict = getFromJsonFile(fileName: fileName) {
            return (dict["list"] as? NSArray) ?? []
        }
        return []
    }
    
    static func deleteFile(fileName: String) {
        if fileName.isEmpty || !fileExists(fileName: fileName) { return }
        
        do {
            try FileManager.default.removeItem(atPath: getFilePath(fileName))
            print("[FileHelper] deleteFile(\(fileName))")
        }
        catch let error as NSError {
            print("[FileHelper]", error)
        }
    }
    
    static func size(fileName: String) -> Int {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: getFilePath(fileName))
            return attr[FileAttributeKey.size] as! Int
        } catch {
            print("Error: \(error)")
        }
        return 0
    }
    
    static func moveFile(fileName: String, toName: String) {
        if fileName.isEmpty || toName.isEmpty { return }
        
        if !fileExists(fileName: fileName) { return }
        if fileExists(fileName: toName) { return }
        
        do {
            try FileManager.default.moveItem(atPath: getFilePath(fileName), toPath: getFilePath(toName))
            print("[FileHelper] moveFile(\(fileName) -> \(toName))")
        }
        catch let error as NSError {
            print("[FileHelper]", error)
        }
    }
    
    static func copyFile(from: String, to: String) {
        if from.isEmpty || to.isEmpty { return }
        
        do {
            try FileManager.default.copyItem(atPath: from, toPath: to)
            print("[FileHelper] copyFile(\(from) -> \(to))")
        }
        catch let error as NSError {
            print("[FileHelper]", error)
        }
    }
    
    static func directory(fullPath: Bool = true) -> [String] {
        guard let documentsUrl = getPathUrl() else { return [] }
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            var list = [String]()
            for url in directoryContents {
                list.append(fullPath ? url.absoluteString : url.absoluteString.split("/").last ?? "")
            }
            return list
        }
        catch {
            print("[FileHelper] \(error)")
        }
        return []
    }
    
    static func directory(ext: String, desc: Bool = true) -> [String] {
        guard let documentsUrl = getPathUrl() else { return [] }
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            if ext.isEmpty {
                return directoryContents.map{ $0.lastPathComponent }
            }
            // if you want to filter the directory contents you can do like this:
            let file = directoryContents.filter{ $0.pathExtension == ext }
            let list = file.map{ $0.deletingPathExtension().lastPathComponent }
            return desc ? list.sorted(by: { $0 > $1 }) : list.sorted(by: { $0 < $1 })
        }
        catch {
            print("[FileHelper] \(error)")
        }
        return []
    }
    
}

//
//  BaseMessage.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class BaseMessage: Codable {
    
    class Filter: Codable {
        var origin_content: String?
        var type: [String]?
    }

    class FileInfo: Codable {
        var type: String
        var name: String
        var url: String
        var size: Int
    }

    var type = ""
    var message_id: Int64 = 0
    var channel_id = ""
    var created_at: Int64 = 0
    var updated_at: Int64?
    var user: BaseUser?
    var content: String?
    var filter: Filter?
    var file: FileInfo?
    var meta: [String:String]?

    static func from(json: String) -> BaseMessage? {
        do {
            return try JSONDecoder().decode(BaseMessage.self, from: Data(json.utf8))
        }
        catch {
            print(error)
            return nil
        }
    }
    
    var json: String {
        do {
            let data = try JSONEncoder().encode(self)
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(decoding: jsonData, as: UTF8.self)
            }
            else {
                return ""
            }
        }
        catch {
            print(error)
            return ""
        }
    }
    
    static func json(from: [BaseMessage]) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(from)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        }
        catch {
            return "Error encoding array of objects to JSON: \(error)"
        }
    }
    
    var content2: String? {
        if type == "text" {
            return text
        }
        else if isImage {
            return "[Picture]"
        }
        else {
            return "[File]"
        }
    }

    var isImage: Bool {
        guard let file = file else { return false }
        return file.url.endsWith(".jpeg") ||
               file.url.endsWith(".jpg") ||
               file.url.endsWith(".png") ||
               file.url.endsWith(".gif");
    }

    var text: String? {
        if type != "text" { return nil }

        if let meta = meta, let value = meta["text"] {
            return value + " [Edited]"
        }
        return content
    }

    var url: String? {
        guard let file = file else { return nil }

        return file.url
    }

}

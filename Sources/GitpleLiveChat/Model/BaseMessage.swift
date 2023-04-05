//
//  BaseMessage.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class BaseMessage: Codable {
    
    public class Filter: Codable {
        public var origin_content: String?
        public var type: [String]?
    }

    public class FileInfo: Codable {
        public var type: String
        public var name: String
        public var url: String
        public var size: Int
    }

    public var type = ""
    public var message_id: Int64 = 0
    public var channel_id = ""
    public var created_at: Int64 = 0
    public var updated_at: Int64?
    public var user: BaseUser?
    public var content: String?
    public var filter: Filter?
    public var file: FileInfo?
    public var meta: [String:String]?

    public static func from(json: String) -> BaseMessage? {
        do {
            return try JSONDecoder().decode(BaseMessage.self, from: Data(json.utf8))
        }
        catch {
            print(error)
            return nil
        }
    }
    
    public var json: String {
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
    
    public static func json(from: [BaseMessage]) -> String? {
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
    
    public var content2: String? {
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

    public var isImage: Bool {
        guard let file = file else { return false }
        return file.url.endsWith(".jpeg") ||
               file.url.endsWith(".jpg") ||
               file.url.endsWith(".png") ||
               file.url.endsWith(".gif");
    }

    public var text: String? {
        if type != "text" { return nil }

        if let meta = meta, let value = meta["text"] {
            return value + " [Edited]"
        }
        return content
    }

    public var url: String? {
        guard let file = file else { return nil }

        return file.url
    }

}

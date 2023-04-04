//
//  BaseUser.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class BaseUser: Codable {
    
    public var user_id = ""
    public var name = ""
    public var created_at: Int64 = 0
    public var updated_at: Int64?
    public var profile_url: String?
    public var meta: [String:String]?
    public var joined_at: Int64?
    
    public static func from(json: String) -> BaseUser? {
        do {
            return try JSONDecoder().decode(BaseUser.self, from: Data(json.utf8))
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
    
    public static func json(from: [BaseUser]) -> String? {
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
    
}

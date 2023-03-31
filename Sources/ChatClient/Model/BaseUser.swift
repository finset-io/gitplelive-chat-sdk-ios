//
//  BaseUser.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

class BaseUser: Codable {
    
    var user_id = ""
    var name = ""
    var created_at: Int64 = 0
    var updated_at: Int64?
    var profile_url: String?
    var meta: [String:String]?
    var joined_at: Int64?
    
    static func from(json: String) -> BaseUser? {
        do {
            return try JSONDecoder().decode(BaseUser.self, from: Data(json.utf8))
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
    
    static func json(from: [BaseUser]) -> String? {
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

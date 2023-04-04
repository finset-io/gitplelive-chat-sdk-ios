//
//  BanInfo.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class BanInfo: Codable {
    
    public var user: BaseUser
    public var start_at: Int64 = 0
    public var end_at: Int64?
    public var reason: String?
    
    public static func from(json: String) -> BanInfo? {
        do {
            return try JSONDecoder().decode(BanInfo.self, from: Data(json.utf8))
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
    
    public static func json(from: [BanInfo]) -> String? {
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

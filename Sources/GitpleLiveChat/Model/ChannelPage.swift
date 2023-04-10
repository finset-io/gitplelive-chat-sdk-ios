//
//  ChannelPage.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class ChannelPage: Codable {
    
    public var channels = [GroupChannel]()
    public var next: String?
    
    public static func from(json: String) -> ChannelPage? {
        do {
            return try JSONDecoder().decode(ChannelPage.self, from: Data(json.utf8))
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
    
}

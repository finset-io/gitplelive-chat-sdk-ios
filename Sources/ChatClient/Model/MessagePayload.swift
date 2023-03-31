//
//  MessagePayload.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

class MessagePayload: Codable {
    
    var category = ""
    var app_id = ""
    var user: BaseUser?
    var channel: GroupChannel?
    var message: BaseMessage?
    var banInfo: BanInfo?
    
    static func from(json: String) -> MessagePayload? {
        do {
            return try JSONDecoder().decode(MessagePayload.self, from: Data(json.utf8))
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

}

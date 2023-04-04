//
//  GroupChannel.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class GroupChannel: Codable {

    var channel_id = ""
    var type = "group"
    var name = ""
    var freeze = false
    var total_message_count = 0
    var total_file_count = 0
    var created_at: Int64 = 0
    var updated_at: Int64 = 0
    var profile_url: String?
    var meta: [String:String]?
    var members: [BaseUser]?
    var managers: [BaseUser]?
    var unread: [String:Int]?
    var read_receipt: [String:Int64]?
    var delivery_receipt: [String:Int64]?
    var last_message: BaseMessage?
    
    static func from(json: String) -> GroupChannel? {
        do {
            return try JSONDecoder().decode(GroupChannel.self, from: Data(json.utf8))
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
    
    func getUnread(userId: String) -> Int {
        guard let unread = unread else { return 0 }
        guard let unread2 = unread[userId] else { return 0 }
        return unread2
    }
    
    func getReadReceipt(userId: String) -> Int64 {
        guard let read_receipt = read_receipt else { return 0 }
        guard let read_receipt2 = read_receipt[userId] else { return 0 }
        return read_receipt2
    }
    
    func getDeliveryReceipt(userId: String) -> Int64 {
        guard let delivery_receipt = delivery_receipt else { return 0 }
        guard let delivery_receipt2 = delivery_receipt[userId] else { return 0 }
        return delivery_receipt2
    }

    var timestamp: Int64 {
        guard let last_message = last_message else { return 1000000000000 }
        return last_message.created_at
    }

}

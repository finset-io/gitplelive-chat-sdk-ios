//
//  GroupChannelMessageSdk.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class GroupChannelMessageSdk {
    
    var userId: String { return GitpleLiveChat.shared.userId }
    var headers: [String:String] { return GitpleLiveChat.shared.headers }
    var url_group_channels: String { return "https://" + GitpleLiveChat.shared.host + "/v1/sdk/group/channels/" }
        
    func create(channelId: String,
                type: String,
                content: String,
                meta: [String:String]?,
                completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/messages"
        
        let dict: NSMutableDictionary = ["channel_id": channelId, "type": type, "content": content]
        if let meta = meta {
            dict.setValue(meta, forKey: "meta")
        }
        
        NetworkHelper.postRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func delete(channelId: String, messageId: Int64, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/messages/\(messageId)"
        
        NetworkHelper.deleteRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func deleteMeta(channelId: String, messageId: Int64, keys: [String], completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/messages/\(messageId)/meta"
        
        let dict: NSDictionary = ["keys": keys]
        NetworkHelper.deleteRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func get(channelId: String, messageId: Int64, mode: String?, type: String?, limit: Int, content: String?, completion: @escaping (String?, String?) -> ()) {
        var url = url_group_channels + channelId + "/messages"

        var params = ""
        if messageId > 0 {
            params += "base_message_id=/\(messageId)"
        }
        if let mode = mode {
            params += (params == "" ? "" : "&") + "mode=" + mode
        }
        if let type = type {
            params += (params == "" ? "" : "&") + "type=" + type
        }
        if limit > 0 {
            params += (params == "" ? "" : "&") + "limit=\(limit)"
        }
        if let content = content {
            params += (params == "" ? "" : "&") + "content=" + content
        }
        if params != "" {
            url += "?" + params
        }

        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func updateMeta(channelId: String, messageId: Int64, meta: [String:String], completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/messages/\(messageId)/meta"

        let dict: NSDictionary = ["meta": meta]
        
        NetworkHelper.putRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    
}

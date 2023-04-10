//
//  GroupChannelSdk.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class GroupChannelSdk {
    
    var userId: String { return GitpleLiveChat.shared.userId }
    var headers: [String:String] { return GitpleLiveChat.shared.headers }
    var url_group_channels: String { return "https://" + GitpleLiveChat.shared.host + "/v1/sdk/group/channels/" }
    
    func ban(channelId: String,
             userId: String,
             seconds: Int?,
             reason: String?,
             completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/ban"
        
        let dict: NSMutableDictionary = ["user_id": userId]
        if let seconds = seconds {
            dict.setValue(seconds, forKey: "seconds")
        }
        if let reason = reason {
            dict.setValue(reason, forKey: "reason")
        }
        
        NetworkHelper.postRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func create(channelId: String,
                name: String,
                profile: String?,
                members: [String],
                reuse: Bool,
                meta: [String:String]?,
                completion: @escaping (String?, String?) -> ()) {
        let dict: NSMutableDictionary = ["channel_id": channelId, "name": name, "members": members, "reuse": reuse]
        if let profile = profile {
            dict.setValue(profile, forKey: "profile_url")
        }
        if let meta = meta {
            dict.setValue(meta, forKey: "meta")
        }
        
        NetworkHelper.postRequest(url: url_group_channels, headers: headers, body: dict.json, completion: completion)
                           
    }

    func delete(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId
        
        NetworkHelper.deleteRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func deleteMeta(channelId: String, keys: [String], completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/meta"
        
        let dict: NSDictionary = ["keys": keys]
        NetworkHelper.deleteRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func delivered(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/messages/delivered"

        NetworkHelper.putRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func findAll(completion: @escaping (String?, String?) -> ()) {
        NetworkHelper.getRequest(url: url_group_channels, headers: headers, completion: completion)
    }

    func findAll(next: String?,
                 limit: Int,
                 showMembers: Bool,
                 showManagers: Bool,
                 showReadReceipt: Bool,
                 showDeliveryReceipt: Bool,
                 showUnread: Bool,
                 showLastMessage: Bool,
                 name: String?,
                 include_members: String?,
                 completion: @escaping (String?, String?) -> ()) {
        var url = url_group_channels

        url += "?limit=\((limit < 5 || limit > 30) ? 15 : limit)"
        url += "&show_members=\(showMembers)"
        url += "&show_managers=\(showManagers)"
        url += "&show_read_receipt=\(showReadReceipt)"
        url += "&show_delivery_receipt=\(showDeliveryReceipt)"
        url += "&show_unread=\(showUnread)"
        url += "&show_last_message=\(showLastMessage)"
        if let name = name { url += "&name=" + name }
        if let include_members = include_members { url += "&include_members=" + include_members }
        if let next = next { url += "&next=" + next }

        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    //-----------------------------------------------------------------------
    // 내부용: 4. mqtt topic 구독용 채널 조회
    //-----------------------------------------------------------------------
    private var channelPage = ChannelPage()
    
    func findAllJoined(completion: @escaping (String?, String?) -> ()) {
        channelPage.channels.removeAll()
        
        findAllJoined(next: nil, completion: completion)
    }
    
    func findAllJoined(next: String?, completion: @escaping (String?, String?) -> ()) {
        var url = url_group_channels + "joined/list?show_managers=true&limit=30"
        if let next = next {
            url += "&next=" + next
        }
        NetworkHelper.getRequest(url: url, headers: headers) { data, error in
            if let error = error {
                completion(nil, error)
            }
            else if let data = data, let page = ChannelPage.from(json: data) {
                self.channelPage.channels.append(contentsOf: page.channels)
                if let next = page.next {
                    self.findAllJoined(next: next, completion: completion)
                }
                else {
                    completion(self.channelPage.json, nil)
                }
            }
            else {
                completion(nil, ErrorType.message(errorType: ErrorType.UNKNOWN_ERROR))
            }
        }
    }

    func findAllJoined(next: String?,
                       limit: Int,
                       showMembers: Bool,
                       showManagers: Bool,
                       showReadReceipt: Bool,
                       showDeliveryReceipt: Bool,
                       showUnread: Bool,
                       showLastMessage: Bool,
                       name: String?,
                       include_members: String?,
                       completion: @escaping (String?, String?) -> ()) {
        var url = url_group_channels + "joined/list"
        
        url += "?limit=\((limit < 5 || limit > 30) ? 15 : limit)"
        url += "&show_members=\(showMembers)"
        url += "&show_managers=\(showManagers)"
        url += "&show_read_receipt=\(showReadReceipt)"
        url += "&show_delivery_receipt=\(showDeliveryReceipt)"
        url += "&show_unread=\(showUnread)"
        url += "&show_last_message=\(showLastMessage)"
        if let name = name { url += "&name=" + name }
        if let include_members = include_members { url += "&include_members=" + include_members }
        if let next = next { url += "&next=" + next }

        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func findBanList(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/banned_list"
        
        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func findManagers(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/managers"
        
        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func findMembers(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/members"
        
        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func findOne(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId

        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func findOnlineMembers(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/online_members"

        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    func freeze(channelId: String, freeze: Bool, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/freeze"

        let dict: NSDictionary = ["freeze": freeze]
        NetworkHelper.putRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func join(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/join"
        
        NetworkHelper.putRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func leave(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/leave"
        
        NetworkHelper.putRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func read(channelId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/messages/read"
        
        NetworkHelper.putRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func registerManager(channelId: String, userId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/managers"

        let dict: NSDictionary = ["manager": userId]
        
        NetworkHelper.postRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func unban(channelId: String, userId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/ban/" + userId
        
        NetworkHelper.deleteRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    func unregisterManager(channelId: String, userId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/managers"

        let dict: NSDictionary = ["manager": userId]
        
        NetworkHelper.deleteRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func update(channelId: String, name: String, profile: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId

        let dict: NSDictionary = ["name": name, "profile_url": profile]
        
        NetworkHelper.putRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func updateMeta(channelId: String, meta: [String:String], completion: @escaping (String?, String?) -> ()) {
        let url = url_group_channels + channelId + "/meta"

        let dict: NSDictionary = ["meta": meta]
        
        NetworkHelper.putRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

}

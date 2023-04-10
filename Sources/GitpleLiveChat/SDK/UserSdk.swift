//
//  UserSdk.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class UserSdk {
    
    var userId: String { return GitpleLiveChat.shared.userId }
    var headers: [String:String] { return GitpleLiveChat.shared.headers }
    var url_users: String { return "https://" + GitpleLiveChat.shared.host + "/v1/sdk/users/" }
        
    func deleteMeta(keys: [String], completion: @escaping (String?, String?) -> Void) {
        let url = url_users + userId + "/meta";
        
        let dict: NSDictionary = ["keys": keys]
        
        NetworkHelper.deleteRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func find(completion: @escaping (String?, String?) -> ()) {
        let url = url_users + "info/me";

        NetworkHelper.getRequest(url: url, headers: headers, completion: completion)
    }

    //-----------------------------------------------------------------------
    // 내부용: 3. Client ID로 SDK 토큰 발급용
    //-----------------------------------------------------------------------
    func generateTokenBySession(clientId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_users + "token/by_client_id";

        let dict: NSDictionary = ["clientId": clientId]
        
        NetworkHelper.postRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }
    
    func read(channels: [String], completion: @escaping (String?, String?) -> ()) {
        let url = url_users + "messages/read";

        let dict: NSDictionary = ["channels": channels]
        
        NetworkHelper.putRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }
    
    //-----------------------------------------------------------------------
    // 내부용: 2. 입력 받은 세션 토큰으로 SDK 토큰 발급용
    //-----------------------------------------------------------------------
    func refreshToken(completion: @escaping (String?, String?) -> ()) {
        let url = url_users + "token";

        NetworkHelper.postRequest(url: url, headers: headers, body: nil, completion: completion)
    }

    //-----------------------------------------------------------------------
    // 내부용: 5. 푸시 토큰 등록용
    //-----------------------------------------------------------------------
    func registerDeviceToken(clientId: String, pushToken: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_users + "device_token";
        
        let dict: NSDictionary = ["clientId": clientId, "token": pushToken]
        
        NetworkHelper.postRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }
    
    //-----------------------------------------------------------------------
    // 내부용: 6. 푸시 토큰 삭제용
    //-----------------------------------------------------------------------
    func deleteDeviceToken(clientId: String, completion: @escaping (String?, String?) -> ()) {
        let url = url_users + "device_token";

        let dict: NSDictionary = ["clientId": clientId]
        
        NetworkHelper.deleteRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }

    func update(name: String, profile: String, completion: @escaping (String?, String?) -> ()) {
        let dict: NSDictionary = ["name": name, "profile_url": profile]
        
        NetworkHelper.putRequest(url: url_users, headers: headers, body: dict.json, completion: completion)
    }

    func updateMeta(meta: [String: String], completion: @escaping (String?, String?) -> ()) {
        let url = url_users + userId + "/meta";
        
        let dict: NSDictionary = ["meta": meta]
        
        NetworkHelper.putRequest(url: url, headers: headers, body: dict.json, completion: completion)
    }
    
}

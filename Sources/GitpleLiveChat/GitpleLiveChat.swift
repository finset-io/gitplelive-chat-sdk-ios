//
//  ChatClient.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class GitpleLiveChat: ChatClientSdk {
    
    public var delegate: ConnectionDelegate? {
        get {
            return connectionEvent
        }
        set(value) {
            connectionEvent = value
        }
    }
    
    public static var shared: GitpleLiveChat!
    
    public static var user: UserApi = UserApi()
    public static var groupChannel = GroupChannelApi()
    public static var groupChannelMessage = GroupChannelMessageApi()
    
    public static func setup(host: String, appId: String) {
        shared = GitpleLiveChat(host: host, appId: appId)
    }
    
}

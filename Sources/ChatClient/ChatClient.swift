//
//  ChatClient.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class ChatClient: ChatClientSdk {
    
    public var delegate: ConnectionDelegate? {
        get {
            return connectionEvent
        }
        set(value) {
            connectionEvent = value
        }
    }
    
    public static var shared: ChatClient!
    
    public static var user: UserApi = UserApi()
    public static var groupChannel = GroupChannelApi()
    public static var groupChannelMessage = GroupChannelMessageApi()
    
    public static func setup(host: String, appId: String) {
        shared = ChatClient(host: host, appId: appId)
    }
    
}

//
//  ChatClient.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

class ChatClient: ChatClientSdk {
    
    var delegate: ConnectionDelegate? {
        get {
            return connectionEvent
        }
        set(value) {
            connectionEvent = value
        }
    }
    
    static var shared: ChatClient!
    
    static var user: UserApi = UserApi()
    static var groupChannel = GroupChannelApi()
    static var groupChannelMessage = GroupChannelMessageApi()
    
    static func setup(host: String, appId: String) {
        shared = ChatClient(host: host, appId: appId)
    }
    
}

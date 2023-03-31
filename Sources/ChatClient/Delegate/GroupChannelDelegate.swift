//
//  GroupChannelDelegate.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

protocol GroupChannelDelegate {

    func onUpdated(channel: GroupChannel)
    
    func onDeleted(channel: GroupChannel)
    
    func onJoined(channel: GroupChannel, user: BaseUser)
    
    func onLeft(channel: GroupChannel, user: BaseUser)
    
    func onManagerCreated(channel: GroupChannel, user: BaseUser)
    
    func onManagerDeleted(channel: GroupChannel, user: BaseUser)
    
    func onFrozen(channel: GroupChannel)
    
    func onUnfrozen(channel: GroupChannel)
    
    func onUserBanned(channel: GroupChannel, user: BaseUser, banInfo: BanInfo)
    
    func onUserUnbanned(channel: GroupChannel, user: BaseUser)
    
    func onMessageCreated(channel: GroupChannel, message: BaseMessage)
    
    func onMessageUpdated(channel: GroupChannel, message: BaseMessage)
    
    func onMessageDeleted(channel: GroupChannel, message: BaseMessage)
    
    func onMessageRead(channel: GroupChannel)
    
    func onMessageDelivered(channel: GroupChannel)

}

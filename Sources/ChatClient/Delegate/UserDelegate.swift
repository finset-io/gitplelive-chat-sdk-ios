//
//  UserDelegate.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public protocol UserDelegate {

    func onUpdate(user: BaseUser)
    
    func onDelete(user: BaseUser)
    
    func onJoined(channel: GroupChannel, user: BaseUser)
    
    func onManager(channel: GroupChannel, user: BaseUser)
    
}

//
//  ConnectionDelegate.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

protocol ConnectionDelegate {

    func onError(errorType: Int)
    
    func onConnected(status: String)
    
    func onReconnected(status: String)
    
    func onDisconnected(status: String)

}

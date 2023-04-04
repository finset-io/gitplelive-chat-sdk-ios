//
//  MessagePage.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class MessagePage: Codable {

    public var messages = [BaseMessage]()
    
    public static func from(json: String) -> MessagePage? {
        do {
            return try JSONDecoder().decode(MessagePage.self, from: Data(json.utf8))
        }
        catch {
            print(error)
            return nil
        }
    }

}

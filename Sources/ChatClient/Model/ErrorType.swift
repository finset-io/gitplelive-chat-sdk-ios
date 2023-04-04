//
//  ErrorType.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class ErrorType {

    static let INVALID_PARAMETERS = 60101
    static let INVALID_TOKEN = 60102
    static let EXPIRED_TOKEN = 60103
    static let INVALID_CHANNEL_ID = 60104
    static let SERVER_NOT_RESPONDING = 60901
    static let UNABLE_CONNECT_ERROR = 60902
    static let UNABLE_SUBSCRIBE_ERROR = 60903
    static let NOT_CONNECTED = 60904
    static let UNKNOWN_ERROR = 60999
    
    static func message(errorType: Int) -> String {
        if (errorType == 1001) { return "Invalid or missing parameters." }
        else if (errorType == 1002) { return "The requested resource could not be found." }
        else if (errorType == 1003) { return "The requested channel could not be found." }
        else if (errorType == 1004) { return "The requested user could not be found." }
        else if (errorType == 1005) { return "The requested message could not be found." }
        else if (errorType == 1006) { return "Member already joined." }
        else if (errorType == 1007) { return "Duplicate ID." }
        else if (errorType == 1008) { return "Not Joined." }
        else if (errorType == 1009) { return "Frozen channel." }
        else if (errorType == 1010) { return "Number of members exceeded." }
        else if (errorType == 1011) { return "Number of managers exceeded." }
        else if (errorType == 1012) { return "File size exceeded." }
        else if (errorType == 1013) { return "Token usage is off." }
        else if (errorType == 1014) { return "Key count exceeded." }
        else if (errorType == 1015) { return "User token usage is off." }
        else if (errorType == 1016) { return "Not a registered manager." }
        else if (errorType == 1017) { return "Managers can not ban each other." }
        else if (errorType == 1018) { return "Can not ban yourself." }
        else if (errorType == 1019) { return "Join is a banned user." }
        else if (errorType == 1020) { return "Profanity in content." }
        else if (errorType == 3001) { return "No permissions." }
        else if (errorType == 4001) { return "Unauthorized." }
        else if (errorType == 4002) { return "Unauthorized organization." }
        else if (errorType == 4003) { return "Unauthorized application." }
        else if (errorType == 9001) { return "Too Many Requests." }
        else if (errorType == 9999) { return "Unknown Server Error." }

        else if (errorType == INVALID_PARAMETERS) { return "Check the sdk initialization init parameters." }
        else if (errorType == INVALID_TOKEN) { return "Invalid session token." }
        else if (errorType == EXPIRED_TOKEN) { return "Generate token again." }
        else if (errorType == INVALID_CHANNEL_ID) { return "Invalid channel ID." }
        else if (errorType == SERVER_NOT_RESPONDING) { return "The server is not responding." }
        else if (errorType == UNABLE_CONNECT_ERROR) { return "Unable to connect to the server." }
        else if (errorType == UNABLE_SUBSCRIBE_ERROR) { return "Unable to subscribe to the event." }
        else if (errorType == NOT_CONNECTED) { return "The device is not connected to the server." }
        else if (errorType == UNKNOWN_ERROR) { return "Check the message on the console." }

        return ""
    }

}

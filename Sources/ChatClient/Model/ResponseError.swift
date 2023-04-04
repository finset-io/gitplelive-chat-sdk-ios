//
//  ResponseError.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class ResponseError: Codable {
    
    var status = 0
    var timestamp = ""
    var path = ""
    var message = ""
    var code = ErrorType.UNKNOWN_ERROR
    
    init(message: String) {
        self.message = message;
    }

    static func from(json: String) -> ResponseError? {
        do {
            return try JSONDecoder().decode(ResponseError.self, from: Data(json.utf8))
        }
        catch {
            print(error)
            return nil
        }
    }
    
    var json: String {
        do {
            let data = try JSONEncoder().encode(self)
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                return String(decoding: jsonData, as: UTF8.self)
            }
            else {
                return ""
            }
        }
        catch {
            print(error)
            return ""
        }
    }

}

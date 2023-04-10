//
//  TokenInfo.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class TokenInfo: Codable {

    var token: String = ""
    var expires_at: Int64 = 0
    
    public static func from(json: String) -> TokenInfo? {
        do {
            return try JSONDecoder().decode(TokenInfo.self, from: Data(json.utf8))
        }
        catch {
            print(error)
            return nil
        }
    }
    
    public var json: String {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8) ?? ""
        }
        catch {
            print(error)
            return ""
        }
    }
}

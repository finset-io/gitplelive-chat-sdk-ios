//
//  JWT.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class JWT: Codable {

    public class Header: Codable {
        var alg = ""
        var typ = ""

        var isJWT: Bool { return typ == "JWT" }
    }

    public class Body: Codable {
        var user_id = ""
        var iat: Int64 = 0
        var exp: Int64 = 0

        var isExpired: Bool { return exp < Date.currentTimeStamp }
    }

    public var jwt = ""

    public func JWT(jwt: String) {
        self.jwt = jwt
    }

    public func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        if segments.count > 1 {
            return decodeJWTPart(segments[1]) ?? [:]
        }
        return [:]
    }

    public func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    public func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }

        return payload
    }

} // JWT.java

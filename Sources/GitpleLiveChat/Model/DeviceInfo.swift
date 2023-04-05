//
//  DeviceInfo.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

public class DeviceInfo: Codable {
    
    public static var deviceId: String {
        if let id = Util.load("device_id") {
            return id
        }
        let id2 = UUID().uuidString
        Util.save("device_id", id2)
        return id2
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

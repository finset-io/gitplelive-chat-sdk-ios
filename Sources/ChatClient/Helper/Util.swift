//
//  Util.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import WebKit
import Alamofire

class Util {
    
    static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }
    
    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
    
    static var space: String {
        return "\u{2800}"
    }
    
    static func exit2() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    static func load(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func save(_ key: String, _ data: String?) {
        UserDefaults.standard.set(data, forKey: key)
    }
        
    static func onForeground(_ completion: @escaping () -> Void) {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { notification in
            completion()
        }
    }
    
    static func onBackground(_ completion: @escaping () -> Void) {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { notification in
            completion()
        }
    }
    
    struct Connectivity {
      static let sharedInstance = NetworkReachabilityManager()!
      static var isConnectedToInternet:Bool {
          return self.sharedInstance.isReachable
        }
    }
    
    static var isNetwork: Bool {
        return Connectivity.isConnectedToInternet
    }
    
    static func alarmSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    static func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func array(from: String) -> [String]? {
        let jsonData = from.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let array = try decoder.decode([String].self, from: jsonData)
            return array
        }
        catch {
            print("Error decoding JSON to array of strings: \(error)")
            return nil
        }
    }
    
}

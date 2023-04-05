//
//  Data.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

extension Data {
    
    init(fileName: String) {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        self = try! Data(contentsOf: docDir.appendingPathComponent(fileName))
    }
    
    var deserialize: NSDictionary? {
        do {
            guard let dict = try JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary else { return nil }
            return dict
        } catch {
            //print("[Data]", error)
            return nil
        }
    }

    var deserializeToArray: NSArray? {
        do {
            guard let array = try JSONSerialization.jsonObject(with: self, options: []) as? NSArray else { return nil }
            return array
        } catch {
            //print("[Data]", error)
            return nil
        }
    }

    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    
    var bytes: [UInt8] {
        return self.hexEncodedString().bytes
    }
    
    var string: String {
        return String(decoding: self, as: UTF8.self)
    }
    
    var crc: UInt8 {
        let data = self.hexEncodedString().bytes
        var crc: UInt8 = UInt8(data.count)
        for datum in data {
            crc ^= datum
        }
        return crc;
    }
}

extension UInt8 {
    
    func equals(_ char: String) -> Bool {
        return self == char.value
    }
    
    var signed: Int {
        if self < 128 { return Int(self) }
        return 128 - Int(self)
    }
    
}

extension UInt16 {
    
    var hexString: HexString {
        return HexString(String(format: "%04x", self))
    }
    
    var psi: String {
        return String(format: "%.1f", "\(self.high).\(self.low)".double)
    }
    
    var signed: Int {
        if self < 0x8000 { return Int(Int(self)) }
        return Int(0x8000 - Int(self))
    }
    
    var high: UInt8 {
        return UInt8(self >> 8)
    }
    
    var low: UInt8 {        
        return UInt8(self & 0x00ff)
    }
}

extension UInt32 {
    
    var hexString: HexString {
        return HexString(String(format: "%08x", self))
    }
}

extension Int {
    
    var celsius: String {
        return String(format: "%d°C", self)
    }
    
    var fahrenheit: String {
        return String(format: "%d°F", self)
    }
    
    var withCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    var ceiling: Int {
        if self <= 1000 { return 1000 }
        else if self <= 200 { return 200 }
        else if self <= 250 { return 250 }
        else if self <= 500 { return 500 }
        else if self <= 750 { return 750 }
        else if self <= 1000 { return 1000 }
        else if self <= 1500 { return 1500 }
        else if self <= 2000 { return 2000 }
        else if self <= 2500 { return 2500 }
        else if self <= 5000 { return 5000 }
        else if self <= 7500 { return 7500 }
        else if self <= 10000 { return 10000 }
        else if self <= 15000 { return 15000 }
        else if self <= 20000 { return 20000 }
        else if self <= 25000 { return 25000 }
        else if self <= 50000 { return 50000 }
        else if self <= 75000 { return 75000 }
        else if self <= 100000 { return 100000 }
        else if self <= 150000 { return 150000 }
        else if self <= 200000 { return 200000 }
        else if self <= 250000 { return 250000 }
        else if self <= 500000 { return 500000 }
        else if self <= 750000 { return 750000 }
        return 1000000
    }

}

extension Double {
    
    var round3: String {
        return String(format: "%.3f", self)
    }
    
    var temperature: String {
        if Locale.current.regionCode == "US" {
            return self.fahrenheit
        }
        return self.celsius
    }
    
    var celsius: String {
        return String(format: "%.0f°C", self)
    }
    
    var fahrenheit: String {
        return String(format: "%.0f°F", (self * 1.8) + 32 )
    }
    
    var kilometer: String {
        return String(format: "%.1f", self / 1000.0)
    }
    
    var kilometer2: String {
        return String(format: "%.2f", self / 1000.0)
    }
    
    var kilometer3: String {
        return String(format: "%.3f", self / 1000.0)
    }
    
    var meter: String {
        return Int(self).withCommas
    }
    
    func distance(meter: Bool) -> String {
        return meter ? self.meter + " m" : self.kilometer + " km"
    }
    
    var ms2kmh: String {
        return String(format: "%.1f", self * 3.6)
    }
    
    var degreesToRadians: Double { return self * .pi / 180.0 }
    var radiansToDegrees: Double { return self * 180.0 / .pi }
}

extension Bundle {
    
    var name: String {
        return (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? object(forInfoDictionaryKey: "CFBundleName") as? String) ?? ""
    }
    
    var version: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    var build: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
    
    var id: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
}

extension Locale {
    
    static var type: Int {
        if self.current.languageCode == "ko" { return 0 }
        if self.current.languageCode == "ch" { return 0 }
        if self.current.languageCode == "ja" { return 0 }
        return 1
    }
    
    static var lang: String {
        if self.current.languageCode == "ko" {
            return "kr"
        }
        return "en"
    }
}

extension NSDictionary {
    
    var string: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .sortedKeys)
            return String.init(data: data, encoding: .utf8) ?? nil
        }
        catch let err {
            print("\(err.localizedDescription)")
            return nil
        }
    }
}

//
//  String.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation
import CoreBluetooth

extension String {
    
    var deserialize: NSDictionary? {
        return self.data(using: .utf8)?.deserialize
    }
    
    var deserializeToArray: [NSDictionary]? {
        guard let dict = ("{\"list\":" + self + "}").deserialize else { return nil }
        return dict["list"] as? [NSDictionary]
    }

    var NSLocalizedDescription: String {
        let arr: [String] = self.split("NSLocalizedDescription=")
        if arr.count < 2 { return "Unknown error" }
        return arr[1].split(",")[0]
    }
    
    var local: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "ko_KR_POSIX")
        let convertedDate = dateFormatter.date(from: self)
        guard dateFormatter.date(from: self) != nil else {
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.string(from: convertedDate!)
    }
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "ko_KR_POSIX")
        let convertedDate = dateFormatter.date(from: self)
        guard dateFormatter.date(from: self) != nil else {
            return Date()
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return Date(dateFormatter.string(from: convertedDate!), utc: true)
    }

    /* var data: Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }

        guard data.count > 0 else { return nil }

        return data
    } */

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var trim: String {
        if self == "null" || self == "<null>" { return "" }
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var encode: String {
        if isEmpty { return "" }
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return self + " >>> e-1"
    }
    
    var decode: String {
        if isEmpty { return "" }
        guard let data = Data(base64Encoded: self.trim.replace("\n", "")) else { return self + " >>> d-1" }
        return String(data: data, encoding: .utf8) ?? self + " >>> d-2"
    }
    
    var urlEncode: String {
        if isEmpty { return "" }
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!.replace("+", "%2B")
    }
    
    func subString(startIndex: Int, length: Int = 0) -> String {
        let endIndex = length == 0 ? self.count - 1 : startIndex + length - 1
        
        if self.count <= endIndex { return self }
        
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
    
    func subString(length: Int) -> String {
        if length > 0 {
            return subString(startIndex: 0, length: length)
        }
        else if length < 0 {
            return subString(startIndex: 0, length: self.count + length)
        }
        return self
    }
    
    func subString(length: Int, _ tail: String) -> String {
        if count <= length {
            return self
        }
        return subString(length: length) + tail
    }
    
    func replace(_ from: String, _ to: String) -> String {
        return self.replacingOccurrences(of: from, with: to)
    }

    func split(_ delimeter: String) -> [String] {
        return self.components(separatedBy: delimeter)
    }

    func indexOf(_ subString: String) -> Int {
        let range = self.range(of: subString)
        return range == nil ? -1 : (range?.lowerBound.utf16Offset(in: subString))!
    }
    
    func startsWith(_ prefix: String) -> Bool {
        return self.hasPrefix(prefix)
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return self.hasSuffix(suffix)
    }
    
    var value: UInt8 {
        return Character(self).asciiValue ?? 0
    }
    
    var ascii: UInt8 {
        return Character(self).asciiValue ?? 0
    }
    
    var byte: UInt8 {
        return UInt8(self) ?? 0
    }
    
    var word: UInt16 {
        return UInt16(self) ?? 0
    }
    
    var unsigned: UInt32 {
        if let value32 = UInt32(self) {
            return value32
        }
        else if let value64 = Int64(self) {
            return UInt32(value64 / 1000)
        }
        return 0
    }
    
    var long: Int {
        return Int(self) ?? 0
    }

    var longlong: Int64 {
        return Int64(self) ?? 0
    }
    
    var double: Double {
        return (self as NSString).doubleValue
    }
    
    var utf8: Data {
        return self.data(using: .utf8)!
    }
    
    var psi: UInt16 {        
        let arr = self.split(".")
        return HexString(arr[0].byte, arr[1].byte).word
    }
    
    var version: Int {
        let arr = self.split(".")
        let ver1 = !self.isEmpty ? arr[0].long : 0
        let ver2 = arr.count > 1 ? arr[1].long : 0
        let ver3 = arr.count > 2 ? arr[2].long : 0
        let ver4 = arr.count > 3 ? arr[3].long : 0
        return (ver1 * 1000000) + (ver2 * 10000) + (ver3 * 100) + ver4
    }
    
    var isUrl: Bool {
        return self.startsWith("http")
    }
    
    var uuid: CBUUID {
        return CBUUID.init(string: self)
    }
    
    var msisdn: MSISDN {
        return MSISDN(self)
    }
    
    var fileName: String {
        if self.isEmpty { return "" }
        let arr = self.split("/")
        return arr[arr.count - 1]
    }
    
    var fileExt: String {
        if self.isEmpty { return "" }
        let arr = fileName.split(".")
        return arr.count > 1 ? arr[arr.count - 1] : ""
    }
    
    func append(_ text: String, _ sep: String = " ") -> String {
        if self.contains(text) { return self }
        return self + (isEmpty ? "" : sep) + text
    }
    
    func append(_ long: Int, _ sep: String = " ") -> String {
        if self.contains("\(long)") { return self }
        return self + (isEmpty ? "" : sep) + "\(long)"
    }
    
    func append(_ longlong: Int64, _ sep: String = " ") -> String {
        if self.contains("\(longlong)") { return self }
        return self + (isEmpty ? "" : sep) + "\(longlong)"
    }
    
}

class MSISDN {
    var number = ""
    var local: String { return korean }
    var korean: String { return number.replace("+82", "0") }
    
    init(_ number: String) {
        self.number = number
    }
}

extension StringProtocol {
    
    var bytes: [UInt8] {
        var startIndex = self.startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}

class HexString: NSObject {

    var value = ""
    
    init(_ string: String) {
        value = string
    }
    
    init(_ byte: UInt8) {
        value = String(format: "%02x", byte)
    }
    
    init(_ high: UInt8, _ low: UInt8) {
        value = String(format: "%02x%02x", high, low)
    }
    
    init(_ byte1: UInt8, _ byte2: UInt8, _ byte3: UInt8, _ byte4: UInt8) {
        value = String(format: "%02x%02x%02x%02x", byte1, byte2, byte3, byte4)
    }
    
    var word: UInt16 {
        return UInt16(value, radix: 16) ?? 0
    }
    
    var unsigned: UInt32 {
        return UInt32(value, radix: 16) ?? 0
    }
    
    var long: Int {
        return Int(value, radix: 16) ?? 0
    }
    
}

extension NSDictionary {
    var json: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .utf8)
    }
}

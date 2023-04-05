//
//  Date.swift
//  GitpleLive SDK Sample App
//
//  Created by Lucetesoft Inc. on 2023/02/23.
//

import Foundation

extension Date {
    
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    init(_ timestamp: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    }
    
    init(_ datetime: String) {
        let dateFormatter = DateFormatter()
        if datetime.split(" ").count < 2 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self = dateFormatter.date(from: datetime) ?? Date()
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = datetime.split(".")[0]
            self = dateFormatter.date(from: date) ?? Date()
        }
    }
    
    init(_ datetime: String, utc: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if utc { dateFormatter.timeZone = TimeZone(abbreviation: "UTC") }
        self = dateFormatter.date(from: datetime.split(".")[0]) ?? Date()
    }
    
    var timestamp: UInt32 {
        return UInt32(self.timeIntervalSince1970)
    }
    
    var seconds: Int {
        return Int(timestamp) - TimeZone.current.secondsFromGMT()
    }
    
    var milliseconds: UInt64 {
        return UInt64(seconds * 1000)
    }
    
    var past: UInt32 {
        return Date().timestamp - self.timestamp
    }
    
    var elapsed: String {
        let time = "\(self)".split(" ")[1]
        if time.starts(with: "00:") { return time.subString(startIndex: 3, length: 5) }
        return time
    }
    
    var elapsed2: String {
        let arr = "\(self)".split(" ")[1].split(":")
        let hour = arr[0].long == 0 ? "" : "\(arr[0].long) " + "hours".localized + " "
        let minute = arr[1].long == 0 ? "" : "\(arr[1].long) " + "minutes".localized + " "
        let second = arr[0].long > 0 || arr[1].long > 0 || arr[2].long == 0 ? "" : "\(arr[2].long) " + "seconds".localized
        
        if time.starts(with: "00:") { return time.subString(startIndex: 3, length: 5) }
        return hour + minute + second
    }

    var cdate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    var datetime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var datetime12: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd a h:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var date2: String {
        if isToday {
            return "today".localized
        }
        else if isYesterday {
            return "yesterday".localized
        }
        else if self.year == Date().year {
            return dayWithMonth
        }
        else {
            return dayWithMonthYear
        }
    }
    
    var dateday: String {
        let arr = description(with: .current).split(" ")
        if Locale.type == 0 {
            return arr[1] + " " + arr[2] + " " + arr[3]
        }
        else {
            return arr[0] + " " + arr[1] + " " + arr[2].replace(",", "")
        }
    }
    
    static var today: String {
        return "today".localized + " " + Date().dateday
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var time12: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var time2: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.string(from: self)
    }

    var minute: String {
        let arr = self.description(with: .current).split(" ")
        if Locale.type == 0 {
            return arr[4] + " " + arr[5] + " " + arr[6]
        }
        else {
            return time12.subString(length: -3)
        }
    }

    var year2: String {
        if Locale.type == 0 {
            return self.description(with: .current).split(" ")[0]
        }
        else {
            return self.description(with: .current).split(" ")[3]
        }
    }

    var month2: String {
        return self.description(with: .current).split(" ")[1]
    }
    
    var day2: String {
        return self.description(with: .current).split(" ")[2].replace(",", "")
    }
    
    var monthWithYear: String {
        if Locale.type == 0 {
            return self.year2 + " " + self.month2
        }
        else {
            return self.month2 + ", " + self.year2
        }
    }
    
    var dayWithMonth: String {
        return self.month2 + " " + self.day2
    }
    
    var dayWithMonthYear: String {
        if Locale.type == 0 {
            return self.year2 + " " + self.dayWithMonth
        }
        else {
            return self.dayWithMonth + ", " + self.year2
        }
    }
    
    var isFuture: Bool {
        return self.year >= Date().year && self.month > Date().month
    }
    
    var isToday: Bool {
        return self.date == Date().date
    }
    
    var isYesterday: Bool {
        return self.date == Date().dayBefore.date
    }

    var previousMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? Date()
    }
    
    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self) ?? Date()
    }

    func daysAgo(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: noon)!
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var dayOfWeek: String {
        return Date.dayOfWeek(index: self.indexOfWeek)
    }
    
    static func dayOfWeek(index: Int) -> String {
        switch index {
            case 0: return "SUN".localized
            case 1: return "MON".localized
            case 2: return "TUE".localized
            case 3: return "WED".localized
            case 4: return "THU".localized
            case 5: return "FRI".localized
            default: return "SAT".localized
        }
    }
    
    var dayOfWeek2: String {
        
        if self.isToday { return "today".localized }
        if self.isYesterday { return "yesterday".localized }
        
        switch self.indexOfWeek {
        case 0: return "sunday".localized
        case 1: return "monday".localized
        case 2: return "tuesday".localized
        case 3: return "wednesday".localized
        case 4: return "thursday".localized
        case 5: return "friday".localized
        default: return "saturday".localized
        }
    }
    
    var indexOfWeek: Int {
        return Calendar.current.component(.weekday, from: self) - 1
    }
    
    var daysInMonth: Int {
        var dateComponents = DateComponents()
        dateComponents.year = self.year
        dateComponents.month = self.month
        if
            let d = Calendar.current.date(from: dateComponents),
            let interval = Calendar.current.dateInterval(of: .month, for: d),
            let days = Calendar.current.dateComponents([.day], from: interval.start, to: interval.end).day
        { return days } else { return -1 }
    }
    
    var datesInMonth: [Date] {
        var list = [Date]()
        for day in 1...self.daysInMonth {
            list.append(Date("\(self.year)-\(self.month)-\(day)"))
        }
        return list
    }
    
    var isInWeek: Bool {
        let date = Calendar.current.date(byAdding: .day, value: 7, to: noon)!
        return Date().date < date.date && self.date <= Date().date
    }
    
    static var isNight: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 6 || hour >= 18
    }
    
}


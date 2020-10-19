//
//  String+Extension.swift
//  Native Email Application
//
//  Created by TMLI IT DEV on 14/10/20.
//

import Foundation
public extension String {
    
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        guard let date = formatter.date(from: self) else {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            return formatter.date(from: self) ?? Date()
        }
        return date
    }
    
}
extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}
public extension Date {
    func dateString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    var moment: String {
        let now = Date()
        let components = Calendar.current.dateComponents(
            [.year, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: now)
        
        let dateFormatterPrint = DateFormatter()
        
        if let years = components.year, years > 0 {
            dateFormatterPrint.dateFormat = "MMM dd,yyyy"
            return dateFormatterPrint.string(from: self)
        }
        
        if let weeks = components.weekOfYear, weeks > 0 {
            if weeks > 1 {
                dateFormatterPrint.dateFormat = "MMM dd"
                return dateFormatterPrint.string(from: self)
            }
            return "\(weeks) Week Ago"
        }
        
        if let days = components.day, days > 0 {
            guard days > 1 else { return "Yesterday" }
            return "\(days) Day\(days == 1 ? "" : "s") Ago"
        }
        
        if let hours = components.hour, hours > 0 {
            return "\(hours) Hour\(hours == 1 ? "" : "s") Ago"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) Minute\(minutes == 1 ? "" : "s") Ago"
        }
        
        if let seconds = components.second, seconds > 30 {
            return "\(seconds) Second\(seconds == 1 ? "" : "s") Ago"
        }
        
        return "Just Now"
    }
}

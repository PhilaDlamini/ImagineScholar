//
//  Announcement.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/22/23.
//

import Foundation

struct Event: Identifiable, Codable {
    var id = UUID().uuidString
    var name : String
    var location : String
    var description : String
    var authorURL: String
    var date: String
    var rsvpd : [String]?
    var rsvpdNames : [String]?
    var rsvpdURLs : [String]?
    
    var displayDate: String {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: date)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date!, to: Date.now)
        let seconds = components.second ?? 0
        let minutes = components.minute ?? 0
        let hours = components.hour ?? 0
        let days = components.day ?? 0
        
        if days > 1 {
            return date!.formatted(date: .abbreviated, time: .omitted)
        } else if hours >= 1 {
            return "\(hours) hr"
        } else if minutes >= 1 {
            return "\(minutes) min"
        }
        
        return "\(seconds) sec"
    }
    
    var displayTime: String {
        "time"
    }

}


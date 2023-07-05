//
//  Forums.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 7/4/23.
//

import Foundation

struct Forum: Identifiable, Codable {
    var id = UUID().uuidString
    var question: String
    var responses: [ForumResponse]?
}

struct ForumResponse: Identifiable, Codable {
    var id = UUID().uuidString
    var authorName: String?
    var authorURL: String?
    var quotedResponse: String?
    var response: String
    var date: String
    
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
}

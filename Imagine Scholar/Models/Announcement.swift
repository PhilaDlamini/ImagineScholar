//
//  Announcement.swift
//  Imagine Scholar
//  Created by Phila Dlamini on 5/24/23.
//

import Foundation
import FirebaseDatabase

struct Announcement: Identifiable, Codable {
    var id = UUID().uuidString
    var author : String
    var authorURL: String
    var content : String
    var followups: [FollowUp]?
    var expiry: String
    var posted = Date().ISO8601Format()

    
    var postedDate: String {
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: posted)
        
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

struct FollowUp: Identifiable, Codable {
    var id = UUID().uuidString
    var author: String
    var imageURL: String
    var content: String
    var responses: [FollowUpResponse]?
}

struct FollowUpResponse: Identifiable, Codable {
    var id = UUID().uuidString
    var author: String
    var imageURL: String
    var content: String
}

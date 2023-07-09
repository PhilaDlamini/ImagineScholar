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
    var posted =  {
        let date = Date()
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }()
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

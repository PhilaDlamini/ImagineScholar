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
    var date = {
        let date = Date()
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }()
    var rsvpd : [String]?
    var rsvpdNames : [String]?
    var rsvpdURLs : [String]?

}


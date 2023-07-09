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

}


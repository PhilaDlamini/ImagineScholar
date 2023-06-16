//
//  Announcement.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/22/23.
//

import Foundation

struct Event: Identifiable {
//    (primaryKey: true) var _id: ObjectId
    //    var questions: [Question]
    var id = UUID()
    var name : String
    var author : String
    var content : String
    var rsvpd : Int
    var timestamp = Date()
    
    //TODO: why must the init be marked as convenience?
}


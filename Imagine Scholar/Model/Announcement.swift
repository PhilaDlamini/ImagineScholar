//
//  Announcement.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/24/23.
//

import Foundation
import RealmSwift

struct Announcement: Identifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
    //    var questions: [Question]
    var id = UUID()
    var author : String
    var content : String
    var timestamp = Date()
    //also questions and answers to those
    
    //TODO: why must the init be marked as convenience?
}


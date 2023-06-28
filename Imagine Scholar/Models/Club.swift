//
//  Club.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/24/23.
//

import Foundation
import RealmSwift

struct Club: Identifiable {
//    @Persisted(primaryKey: true) var _id: ObjectId
    //    var questions: [Question]
    var id = UUID()
    var meetDate = Date()
    var name : String
    var clubDescription : String
    var numMembers : Int
   
    
    //TODO: why must the init be marked as convenience?
}


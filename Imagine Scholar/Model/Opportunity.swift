//
//  Opportunity.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//

import Foundation

struct Opportunity: Identifiable {
    var id = UUID()
    var name : String
    var what: String
    var tag: String //who is it meant for ["all", "students", "alumni"]
    var link : String
    var dueDate = Date()

    
}

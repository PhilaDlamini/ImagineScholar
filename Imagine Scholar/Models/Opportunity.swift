//
//  Opportunity.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//

import Foundation

struct Opportunity: Identifiable, Codable {
    var id = UUID().uuidString
    var name : String
    var content: String
    var tag: String //who is it meant for ["All", "Student", "Alumni"]
    var link: String
    var deadline: String

    
}

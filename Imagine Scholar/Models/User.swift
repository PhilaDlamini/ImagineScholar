//
//  User.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/6/23.
//

import Foundation

struct User: Codable {
    var uid: String
    var name: String
    var email: String
    var type: String //one of ["Student", "Facilitator", "Alumni"]
    var imageURL: String
    
    //add more here as needed
}



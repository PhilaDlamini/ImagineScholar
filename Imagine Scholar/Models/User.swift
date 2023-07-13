//
//  User.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/6/23.
//

import Foundation

/*
 * None of the fields are marked as published because nothing is ever going to change
 */
class User: Codable, ObservableObject {
    var uid: String
    var name: String
    var email: String
    var type: String //one of ["Student", "Facilitator", "Alumni"]
    var imageURL: String
    
    //add more here as needed
    init() {
        uid = ""
        name = ""
        email = ""
        type = ""
        imageURL = ""
    }
    
    init(uid: String, name: String, email: String, type: String, imageURL: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.type = type
        self.imageURL = imageURL
    }
}



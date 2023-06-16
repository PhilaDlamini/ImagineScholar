//
//  DBFunctions.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/6/23.
//

import Foundation
import FirebaseDatabase
import Firebase

//standalone functions for dealing with the data base
func getUser() -> User {
    let ref = Database.database().reference()
    let fbUser = Auth.auth().currentUser!
    var user: User?
    var updated = false
    
    ref.child("users").child(fbUser.uid).observeSingleEvent(of: .value) {snapshot in
        let userData = snapshot.value as! [String: Any]
        user = try! User.fromDict(dictionary: userData)
        print("just loaded user data for \(user!.name)")
        updated = true
    }
    
    while(!updated){}
    return user!
}

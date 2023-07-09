//
//  AddAnnouncementView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/24/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct CreateAnnouncementView: View {
    var user: User?
    @State private var content = ""
    @State private var expiryDate = Date()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section("Announcement") {
                    TextEditor(text: $content)
                }
                
                Section {
                    DatePicker("Expiration date", selection: $expiryDate, displayedComponents: .date)
                    
                }
                Button("Announce", action: announce)
                    .disabled(content.isEmpty)
            }
        }
        .navigationTitle("New Announcement")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    func announce() {
        print("About to annojnce")
        if let user = user {
            let annon = Announcement(author: user.name, authorURL: user.imageURL, content: content, expiry: expiryDate.ISO8601Format())
            
            let ref = Database.database().reference()
            ref.child("announcements").child(annon.id).setValue(try! annon.getDict()) {(error, ref) in
                if let error = error {
                    print("Error creating announcement! \(error.localizedDescription)")
                } else {
                    print("Announcement sent!")
                }
            }
            
            dismiss()
        }
    }
}

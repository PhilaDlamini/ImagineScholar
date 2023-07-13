//
//  CreateEventView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/27/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct CreateEventView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var date = Date.now
    @State private var time = Date.now
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $title)
                    }
                    
                    Section("Description") {
                        TextEditor(text: $description)
                    }
                    
                    Section {
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                        
                        DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute)
                        
                        TextField("Location", text: $location)
                    }
                    
                    Button("Create", action: createEvent)
                }
                
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func createEvent() {
        //TODO: should mix date and time
        let event = Event(name: title, location: location, description: description, authorURL: user.imageURL)
        
        let ref = Database.database().reference()
        ref.child("events").child(event.id).setValue(try! event.getDict()) {(error, ref) in
            if let error = error {
                print("Error creating event! \(error.localizedDescription)")
            } else {
                print("posted event!")
            }
        }
        dismiss()
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}

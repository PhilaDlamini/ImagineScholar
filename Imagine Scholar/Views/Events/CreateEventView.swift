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
    @State private var user: User? = nil
    @Environment(\.dismiss) var dismiss

    var body: some View {
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
        .onAppear {
            //load user
            if let userData = UserDefaults.standard.data(forKey: "user") {
                if let usr = try? JSONDecoder().decode(User.self, from: userData) {
                    user = usr
                }
            }
        }
    }
    
    func createEvent() {
        if let user = user {
            
            //gets the time 
            
            //TODO: mix date and time
            let event = Event(name: title, location: location, description: description, authorURL: user.imageURL, date: Event.getIsoTime(from: date))
            
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
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView()
    }
}

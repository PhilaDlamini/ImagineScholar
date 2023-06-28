//
//  AnnouncementView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/22/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

//Displays the announcement
struct EventView: View {
    var user: User?
    var event : Event
  
    var body: some View {
        NavigationLink(destination: EventDetailsView(event: event)) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    AsyncImage(url: URL(string: event.authorURL)) {phase in
                        
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                        Text("date")//Text(event.displayDate)
                    }
                    
                }
                
                HStack {
                    Rectangle()
                        .frame(width: 1)
                    
                    VStack (alignment: .leading, spacing: 15) {
                        Text(event.description)
                        HStack (spacing: 10) {
                                Button(action: updateRSVP) {
                                    if let user = user {
                                        if let rsvps = event.rsvpd {
                                            if(rsvps.contains(user.uid)) {
                                                Image(systemName: "envelope.fill")
                                                    .foregroundColor(.mint)
                                            } else {
                                                Image(systemName: "envelope")
                                            }
                                        } else {
                                            Image(systemName: "envelope")
                                        }
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                Text("\(event.rsvpd?.count ?? 0)")
                        }
                    }
                    .padding(.leading, 25)
                }
                .padding(.leading, 25)
            }
            
        }
    }
    
    func updateRSVP() {
        
        if let user = user {
            var rsvpd = event.rsvpd ?? []
            var rsvpdNames = event.rsvpdNames ?? []
            var rsvpdURLs = event.rsvpdURLs ?? []
            let ref = Database.database().reference().child("events")
            
            //Unlike if already liked
            if rsvpd.contains(user.uid) {
                
                rsvpd.removeAll {$0 == user.uid}
                rsvpdNames.removeAll {$0 == user.name}
                rsvpdURLs.removeAll {$0 == user.imageURL}
                
                ref.child(event.id).child("rsvpd").setValue(rsvpd) {err, _ in
                    if let err = err {
                        print("Error removing! \(err.localizedDescription)")
                    } else {
                        print("Sent like successfully :)")
                    }
                }
                
                ref.child(event.id).child("rsvpdURLs").setValue(rsvpdURLs) {err, _ in
                    if let err = err {
                        print("Error removing url! \(err.localizedDescription)")
                    } else {
                        print("Removed author URL successfully :)")
                    }
                }
                
                ref.child(event.id).child("rsvpdNames").setValue(rsvpdNames) {err, _ in
                    if let err = err {
                        print("Error removing name! \(err.localizedDescription)")
                    } else {
                        print("Removed name successfully :)")
                    }
                }
                
            } else {
                
                //Else, send rsvp
                rsvpd.append(user.uid)
                rsvpdNames.append(user.name)
                rsvpdURLs.append(user.imageURL)
                
                
                ref.child(event.id).child("rsvpd").setValue(rsvpd) {err, _ in
                    if let err = err {
                        print("Error adding rsvp! \(err.localizedDescription)")
                    } else {
                        print("Sent rsvp successfully :)")
                    }
                }
                
                ref.child(event.id).child("rsvpdURLs").setValue(rsvpdURLs) {err, _ in
                    if let err = err {
                        print("Error adding url! \(err.localizedDescription)")
                    } else {
                        print("Sent authoer URL successfully :)")
                    }
                }
                
                ref.child(event.id).child("rsvpdNames").setValue(rsvpdNames) {err, _ in
                    if let err = err {
                        print("Error adding name! \(err.localizedDescription)")
                    } else {
                        print("Sent name successfully :)")
                    }
                }
            }
        }
    }
}

struct EventsView: View {
    @State private var events = [Event]()
    @State private var user: User? = nil
    let ref = Database.database().reference().child("events")
    
    var body: some View {
        NavigationView {
            List(events) { event in
                EventView(user: user, event: event)
            }
            .toolbar {
                
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Image(systemName: "airplane.circle.fill")
                        Text("Events")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: CreateEventView()) {
                        Label("New Event", systemImage: "plus.circle")
                    }
                }
            }
            .onAppear{
                
                //load the user
                if let userData = UserDefaults.standard.data(forKey: "user") {
                    if let usr = try? JSONDecoder().decode(User.self, from: userData) {
                        user = usr
                    }
                }
                
                //attach listeners
                attachListeners()
            }
        }
    }
    
    func attachListeners() {
        
        //if a new event is added, append it to the list of events
        ref.observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let eventData = snapshot.value as? [String: Any] {
                    let event: Event = try! Event.fromDict(dictionary: eventData)
                    if !events.contains(where: {$0.id == event.id}) {
                        events.insert(event, at: 0)
                    }
                }
            }
        }
        
        //if a event is updated, update the view
        ref.observe(.childChanged) {snapshot in
            for _ in snapshot.children {
                if let eventData = snapshot.value as? [String: Any] {
                    let event: Event = try! Event.fromDict(dictionary: eventData)
                    
                    if let index = events.firstIndex(where: {$0.id == event.id}) {
                        events[index] = event
                    }
                }
            }
        }
        
        //if an event is removed, update the view
        ref.observe(.childRemoved) {snapshot in
           if let eventData = snapshot.value as? [String: Any] {
               let event: Event = try! Event.fromDict(dictionary: eventData)
               events.removeAll(where: {$0.id == event.id})
               print("Removed event")
            }
        }
        
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}

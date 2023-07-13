//
//  EventsDetailsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/27/23.
//

import SwiftUI

struct EventDetailsView: View {
    @State var event: Event
    @EnvironmentObject var user: User

    var body: some View {
        VStack(alignment: .leading) {
            
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
            
            Text(event.description)
            
            HStack {
                Image(systemName: "clock")
                Text(event.getDisplayTime(from: event.date))
            }.padding(.top)
            
            HStack {
                Image(systemName: "location.fill")
                Text(event.location)
            }
            
            HStack {
                Image(systemName: "envelope")
                Text("\(event.rsvpd?.count ?? 0) people are attending")
            }
            
            if let rsvpd = event.rsvpd {
                ScrollView{
                    HStack {
                        ForEach(0..<rsvpd.count,id: \.self) {i in
                            VStack {
                                AsyncImage(url: URL(string: event.rsvpdURLs![i])) {phase in
                                    
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
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                
                                Text(event.rsvpdNames![i])
                            }
                        }
                    }
                }
            }
            
        }
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if user.imageURL == event.authorURL { //TODO: need a stronger  way to authenticate here
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        deleteEvent()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    func deleteEvent() {
        print("Deleting event")
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailsView(event: Event(name: "Phila", location: "Lappa", description: "Come for poetry slam!", authorURL: "some url", date: "2023-06-25T23:16:59.493824"))
    }
}

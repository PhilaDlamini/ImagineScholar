//
//  AnnouncementView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/22/23.
//

import SwiftUI

//Displays the announcement
struct EventView: View {
    var event : Event
  
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.headline)
                    Text(event.timestamp.formatted(date: .abbreviated, time: .omitted))
                }

            }
            
            HStack {
                
                //
                Rectangle()
                    .frame(width: 1)
                
                VStack (alignment: .leading, spacing: 15) {
                    Text(event.content)
                    
                    
                    HStack (spacing: 20) {
                        
                        
                        HStack{
                            Image(systemName: "envelope.fill")
                            Text("\(event.rsvpd)")
                        }
                        
                        HStack{
                            Circle()
                                .fill(.mint)
                                .frame(width: 15, height: 15)
                                
                            Text("\(event.author)")
                        }
                    }
                }
                .padding(.leading, 25)
            }
            .padding(.leading, 25)
//            HStack (spacing: 30) {
//                HStack{
//                    Image(systemName: "heart")
//                    Text("\(post.likes)")
//                }
//                HStack{
//                    Image(systemName: "text.bubble")
//                    Text("\(3)")
//                }
//
//                HStack {
//                Image(systemName: "quote.closing")
//                }
//
//
//            }
        }
    }
}

struct EventsView: View {
    var events = [Event(name: "Poetry Slam", author: "Phila", content: "Just a reminder that students from Groton will be joining us for the Imagine Scholar Poetry slam tomorrow", rsvpd: 2),
      Event(name: "Indaba", author: "Megan", content: "Y'll, sign up please!!", rsvpd: 25),
      Event(name: "Club Showcase", author: "Corey", content: "The coding club will be showcasing an app that they've been working on this past summer! Come and support please!", rsvpd: 265),
      Event(name: "Pizza party", author: "Thenji", content: "RVSP and join the world's largest pizza partei. Let's go!!", rsvpd: 545),
    
    ]
    
    var body: some View {
        List(events) { event in
                EventView(event: event)
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}

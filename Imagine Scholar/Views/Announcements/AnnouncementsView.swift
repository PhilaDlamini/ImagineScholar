//
//  AnnouncementsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/24/23.
//

import SwiftUI

struct AnnouncementView : View {
    let announcement: Announcement
    
    var body : some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading){
                    Text(announcement.author)
                        .font(.headline)
                    Text("38 min ago")
                }
            }
            
            Text(announcement.content)
            
            Button {
                
            } label: {
                Label("Follow up", systemImage: "questionmark.square.dashed")
            }
        }
    }
}

struct AnnouncementsView: View {
    let announcements = [Announcement(author: "Megan Nellis", content: "Remember to grab bottles before you leave!"),
        Announcement(author: "Megan O'Neill", content: "We just got more books for tomorrow's readng celebration. Come grab one!")]
    
    var body: some View {
        List(announcements) { anct in
                AnnouncementView(announcement: anct)
        }
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsView()
    }
}

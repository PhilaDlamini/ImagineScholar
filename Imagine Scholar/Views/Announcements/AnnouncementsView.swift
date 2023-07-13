//
//  AnnouncementsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/24/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct AnnouncementView : View {
    @EnvironmentObject var user: User
    let announcement: Announcement
    
    var body : some View {
        NavigationLink(destination: AnnouncementDetailsView(announcement: announcement)){
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    AsyncImage(url: URL(string: announcement.authorURL)) {phase in
                        
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
                    
                    VStack(alignment: .leading){
                        Text(announcement.author)
                            .font(.headline)
                        Text(announcement.getDisplayTime(from: announcement.posted))
                    }
                }
                
                Text(announcement.content)
                
                if let followUps = announcement.followups {
                    HStack {
                        Image(systemName: "questionmark.app")
                        Text("\(followUps.count) follow ups")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

struct AnnouncementsView: View {
    @State private var creatingAnnouncement = false
    @State private var announcements = [Announcement]()
    @EnvironmentObject var user: User
    let ref = Database.database().reference().child("announcements")
    
    var body: some View {
        NavigationView {
            List(announcements) { annon in
                AnnouncementView(announcement: annon)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Image(systemName: "airplane.circle.fill")
                        Text("Announcements")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        creatingAnnouncement = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .onAppear{
                attachListeners()
            }
            .sheet(isPresented: $creatingAnnouncement) {
                CreateAnnouncementView()
            }
        }
    }
    
    //Listens for changes to announcements
    func attachListeners() {
        
        //if a new announcement is added, append it to the list of annos
        ref.observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let annosData = snapshot.value as? [String: Any] {
                    let annos: Announcement = try! Announcement.fromDict(dictionary: annosData)
                    if !announcements.contains(where: {$0.id == annos.id}) {
                        announcements.insert(annos, at: 0)
                    }
                }
            }
        }
        
        //if an announcement is updated, update the view
        ref.observe(.childChanged) {snapshot in
            for _ in snapshot.children {
                if let annosData = snapshot.value as? [String: Any] {
                    let annos: Announcement = try! Announcement.fromDict(dictionary: annosData)
                    
                    if let index = announcements.firstIndex(where: {$0.id == annos.id}) {
                        announcements[index] = annos
                    }
                }
            }
        }
        
        //if an announcement is removed, update the view
        ref.observe(.childRemoved) {snapshot in
           if let annosData = snapshot.value as? [String: Any] {
               let annos: Announcement = try! Announcement.fromDict(dictionary: annosData)
               announcements.removeAll(where: {$0.id == annos.id})
               print("Removed announcement")
            }
        }
        
        print("Should have attached observers")
    }
}

struct AnnouncementsView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementsView()
    }
}

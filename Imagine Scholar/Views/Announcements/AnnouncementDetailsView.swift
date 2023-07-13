//
//  AnnouncementDetailsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 7/4/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct AnnouncementDetailsView: View {
    @Environment(\.dismiss) var dismiss
    var announcement: Announcement
    @EnvironmentObject var user: User
    @State private var followUp = ""
    
    var body: some View {
        ZStack {
            ScrollView {
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
                        }
                        
                        Rectangle()
                            .fill(.gray)
                            .frame(height: 1)
                        
                        ForEach(followUps) {up in
                            VStack {
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
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                    
                                    /*@START_MENU_TOKEN@*/Text(up.author)/*@END_MENU_TOKEN@*/
                                        .font(.headline)
                                }
                                
                                Text(up.content)
                                    .padding([.leading], 28)
                            }
                            
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    TextField("Follow up", text: $followUp)
                    Spacer()
                    Button {
                        postFollowUp()
                    } label: {
                        Image(systemName: "arrow.up.circle")
                    }.disabled(followUp.isEmpty)
                    
                }
                .padding()
                .background(Capsule().fill(.gray.opacity(0.2)))
            }
        }
        .toolbar {
                if user.imageURL == announcement.authorURL { //TODO: need a stronger  way to authenticate here
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            deleteAnnouncement()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            
        }
        .padding()
    }
    
    //deletes the announcement
    func deleteAnnouncement() {
        let ref = Database.database().reference()
        ref.child("announcements").child(announcement.id).removeValue()
        dismiss()
    }
    
    //adds the follow up to the post
    func postFollowUp() {
        var followups = announcement.followups ?? []
        let follow = FollowUp(author: user.name, imageURL: user.imageURL, content: followUp)
        followups.append(follow)
        
        //convert each follow up to a dictionary
        var coms: [[String:Any]] = []
        for f in followups {
            coms.append(try! f.getDict()!)
        }
        
        let ref = Database.database().reference()
        ref.child("announcements").child(announcement.id).child("followups").setValue(coms) {err, _ in
            if let err = err {
                print("Error adding followup! \(err.localizedDescription)")
            } else {
                print("Successfully added followup!")
                
                followUp = ""
            }
        }
        
    }
}


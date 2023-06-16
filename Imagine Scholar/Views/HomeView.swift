//
//  HomeView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/8/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct HomeView: View {
    @State private var selectedTab = 1
    @State private var accountType = "Student"
    
    var body: some View {

        return ZStack (alignment: .bottomTrailing) {
            TabView (selection: $selectedTab) {
                PostsView()
                    .tag(1)
                    .tabItem{
                        Label("Posts", systemImage: "arrow.up.bin.fill")
                    }
                
                EventsView()
                    .tag(2)
                    .tabItem{
                        Label("Events", systemImage: "calendar")
                    }
                
                
                if accountType == "Student" {
                    
                    AnnouncementsView()
                        .tag(3)
                        .badge(2)
                        .tabItem{
                            Label("Announcents", systemImage: "perspective")
                        }
                    
                    ClubsView()
                        .tag(4)
                        .tabItem{
                            Label("Clubs", systemImage: "suit.club")
                        }
                } else if accountType == "Alumni" {
                   
                    NewslettersView()
                        .tag(3)
                        .tabItem{
                            Label("NewsLetters", systemImage: "newspaper.fill")
                        }
                    
                } else {EmptyView()}
            }
        
            .toolbar {
                
                //TODO: update toolabar stuff to match account type
                //TODO: the code could be a little cleaner phila
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Image(systemName: "airplane.circle.fill")
                        Text(getTitle())
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    if selectedTab == 1 {
                        
                        NavigationLink(destination: OpportunitiesView()) {
                            Label("Ops", systemImage: "heart.text.square.fill")
                        }
                        
                    } else {
                        EmptyView()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if selectedTab == 1 {
                        
                        NavigationLink(destination: CreatePostView(quotedPost: nil)) {
                            Label("New Post", systemImage: "note.text.badge.plus")
                        }
                        
                        
                    } else {
                        EmptyView()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if selectedTab == 3 && accountType == "Student" { //needs fixing if on alumn mode
                        
                        NavigationLink(destination: AddAnnouncementView()) {
                            
                            Label("New Post", systemImage: "plus.diamond")
                            
                        }
                        
                    }
                    
                    else {
                        EmptyView()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if selectedTab == 4 {
                        NavigationLink(destination: AddClubView()) {
                            Text("Add")
                        }
                        
                    } else {
                        EmptyView()
                    }
                }
                
                ToolbarItem { //TODO: --> remove
                    Button("log out") {
                        try! Auth.auth().signOut()
//                        var user = getUser()
                    }
                }
            }
        }
            
    }
    
    //returns the correct title based on the selected tab
    func getTitle() -> String {
        if selectedTab == 1 {
            return "Scholar Posts"
        } else if selectedTab == 2 {
            return "Events"
        } else if selectedTab == 3 {
            if accountType == "Student" {
                return "Announcements"
            } else {
                return "NewsLetter"
            }
        } else {
            return "Clubs"
        }
    }
        
    func goToOps() {
        print("Going to opportunities screen")
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

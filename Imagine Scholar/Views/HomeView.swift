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
                    
                    ChatsView()
                        .tag(3)
                        .tabItem{
                            Label("Chats", systemImage: "message.circle")
                        }
                    
                    AnnouncementsView()
                        .tag(4)
                        .tabItem{
                            Label("Annos", systemImage: "perspective")
                        }
                    
                    ForumsView()
                        .tag(5)
                        .tabItem{
                            Label("Forums", systemImage: "suit.club")
                        }
                } else if accountType == "Alumni" {
                   
                    NewslettersView()
                        .tag(3)
                        .tabItem{
                            Label("NewsLetters", systemImage: "newspaper.fill")
                        }
                    
                } else {EmptyView()}
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

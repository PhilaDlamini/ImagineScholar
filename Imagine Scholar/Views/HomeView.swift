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
    @StateObject private var user = User()
    @State private var userType = ""
    @State private var selectedTab = 1
    
    var body: some View {
        print("user type at time of drawing \(user.type)")
        return TabView (selection: $selectedTab) {
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
            
            
            if userType == "Alumni" {
                OpportunitiesView()
                    .tag(4)
                    .tabItem{
                        Label("Opportunities", systemImage: "circle.hexagongrid")
                    }
                
                NewsLettersView()
                    .tag(5)
                    .tabItem{
                        Label("Newsletters", systemImage: "newspaper")
                    }
            } else {
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

            }
        }
        .onAppear {
            //load the user
            if let userData = UserDefaults.standard.data(forKey: "user") {
                if let u = try? JSONDecoder().decode(User.self, from: userData) {
                    user.uid = u.uid
                    user.name = u.name
                    user.email = u.email
                    user.type = u.type
                    user.imageURL = u.imageURL
                    userType = user.type
                    print("loaded user in homeview")
                    print("user type is \(user.type)")

                }
                
            }
            
            print("user type is \(user.type)")
        }
        .environmentObject(user)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

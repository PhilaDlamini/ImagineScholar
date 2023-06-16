//
//  ContentView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/21/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var screen = "create"
    @State private var loggedIn = false
   
    var body: some View {
        
        NavigationView {
            if loggedIn {
                HomeView()
            } else if screen == "login" {
                LoginView(screen: $screen)
            } else {
                CreateAccountView(screen: $screen)
            }
            
        }
        .onAppear(perform: {
            Auth.auth().addStateDidChangeListener { (auth, user) in
                print("auth state just changed!")
                loggedIn = user != nil
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

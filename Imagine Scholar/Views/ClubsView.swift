//
//  ClubsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/24/23.
//

import SwiftUI

struct ClubView: View {
    let club : Club
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading){
                    Text(club.name)
                        .font(.headline)
                    Text("Meets Fri 2:30 PM")
                        .font(.subheadline)
                }
            }
            
            Text(club.clubDescription)
            
            HStack (spacing: 30) {
                HStack{
                    Image(systemName: "person.2")
                    Text("\(club.numMembers) members")
                }
            
                
                Button ("Join"){
                    
                }
                   
                
            }

        }
    }
}

struct ClubsView: View {
    var clubs = [Club(name: "Binary Instructors", clubDescription: "This club explores the beaty of binary and bathes in the golden sun", numMembers: 23),
    Club(name: "Improv", clubDescription: "Join us for an exciting time every friday as we explore improvized theatre and have fun laughing", numMembers: 50)]
    
    var body: some View {
        List(clubs) { club in
                ClubView(club: club)
        }
    }
}

struct ClubsView_Previews: PreviewProvider {
    static var previews: some View {
        ClubsView()
    }
}

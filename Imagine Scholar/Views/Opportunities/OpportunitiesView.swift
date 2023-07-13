//
//  OpportunitiesView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct OpportunityView : View {
    var opportunity: Opportunity
    
    var body : some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading){
                    Text(opportunity.name)
                        .font(.headline)
                    Text("Due Fri 2:30 PM")
                        .font(.subheadline)
                }
                Spacer()
                Link(destination: URL(string: opportunity.link)!) {
                    Image(systemName: "link.circle.fill")
                }
            }
            Text(opportunity.content)
        }
    }
}

struct OpportunitiesView: View {
    let ref = Database.database().reference().child("opportunities")
    @EnvironmentObject var user: User
    @State private var opportunities = [Opportunity]()
    @State private var addingNew = false
    
    var body: some View {
        List (opportunities) {op in
            OpportunityView(opportunity: op)
        }
        .navigationTitle("Opportunities")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            opportunities.removeAll(where: {$0.tag != user.type || $0.tag == "all"})
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    addingNew = true
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .onAppear {
            attachListeners()
        }
        .sheet(isPresented: $addingNew) {
            AddOpportunityView()
        }
    }
    
    func attachListeners()  {
        
        //if a new opportunity is added, append it to the list of oppportunities
        ref.observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let opData = snapshot.value as? [String: Any] {
                    let op: Opportunity = try! Opportunity.fromDict(dictionary: opData)
                    if !opportunities.contains(where: {$0.id == op.id}) {
                        opportunities.insert(op, at: 0)
                    }
                }
            }
        }
        
        //if an opportunity is updated, update the view
        ref.observe(.childChanged) {snapshot in
            for _ in snapshot.children {
                if let opData = snapshot.value as? [String: Any] {
                    let op: Opportunity = try! Opportunity.fromDict(dictionary: opData)
                    
                    if let index = opportunities.firstIndex(where: {$0.id == op.id}) {
                        opportunities[index] = op
                    }
                }
            }
        }
        
        //if an opportunity is removed, update the view
        ref.observe(.childRemoved) {snapshot in
           if let opData = snapshot.value as? [String: Any] {
               let op: Opportunity = try! Opportunity.fromDict(dictionary: opData)
               opportunities.removeAll(where: {$0.id == op.id})
            }
        }
    }
}

struct OpportunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunitiesView()
    }
}

//TODO: fix showing only revelant ops (broken when a new op is being added) 

//
//  OpportunitiesView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//

import SwiftUI

struct OpportunityView : View {
    var opportunity : Opportunity
    var type : String
    
    var body : some View {
        VStack(alignment: .leading, spacing: 20) {
            
           
            VStack(alignment: .leading){
                Text(opportunity.name)
                    .font(.headline)
                Text("Due Fri 2:30 PM")
                    .font(.subheadline)
            }
    
            
            Text(opportunity.what)
            
            if type == "Facilitator" {
                HStack {
                    Circle()
                        .fill(opportunity.tag == "All" ? .mint : opportunity.tag == "Alumni" ? .accentColor : .indigo)
                        .frame(width: 15, height: 15)
                      
                    Text(opportunity.tag)
                }
            } else {
                Button("Apply here") {
                    
                }
            }
           

        }
    }
}

struct OpportunitiesView: View {
    @AppStorage("type") private var accountType = "Student"

    var opportunities = [Opportunity(name: "YYGS", what: "Go to Yale in New Haven", tag: "Student", link: "https:\\www.google.com"),
     Opportunity(name: "Apple Inc.", what: "Apple has a bunch of job positions open. Apply today!", tag: "Alumni", link: "https:\\www.google.com"),
     Opportunity(name: "Google Inc.", what: "Goole accounting positions!", tag: "Alumni", link: "https:\\www.google.com"),
     Opportunity(name: "Mentors", what: "Mentor other IS students", tag: "All", link: "https:\\www.google.com")
        
    ]
    
    var body: some View {
        List (getOpportunities()) {op in
            OpportunityView(opportunity: op, type: accountType)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: AddOpportunityView()) {
                    Label("Add", systemImage: "plus.circle")
                }
            }
        }
    }
    
    func getOpportunities() -> [Opportunity] {
        if accountType == "Facilitator" {
            return opportunities
        } else {
            return opportunities.filter({$0.tag == accountType || $0.tag == "All"})
        }
    }
}

struct OpportunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunitiesView()
    }
}

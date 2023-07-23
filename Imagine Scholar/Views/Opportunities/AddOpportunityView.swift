//
//  AddOpportunityView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/27/23.
//
import SwiftUI
import Firebase
import FirebaseDatabase

struct AddOpportunityView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var link = ""
    @State private var forWho = "Alumni"
    @State private var deadline = Date.now
    @State private var brokenLink = false
    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    let groups = ["Alumni", "Student", "All"]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $name)
                    }
                    
                    Section("Description") {
                        TextEditor(text: $description)
                    }
                    
                    Section {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                        
                        TextField("Link", text: $link)
                            .keyboardType(.URL)
                            .textContentType(.URL)
                            .textCase(.lowercase)
                        
                        Picker("For", selection: $forWho) {
                            ForEach(groups, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    if brokenLink {
                        Section {
                            Text("Link invalid")
                                .foregroundColor(.red)
                        }
                    }
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        send()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .disabled(link.isEmpty || description.isEmpty || name.isEmpty)
                }
            }
            .navigationTitle("New Opportunity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func getURL() -> String {
        if(link.contains("http")) {return link}
        return "https://\(link)"
    }
    func send() {
        //test link first
        if let url = URL(string: getURL()) { //TODO: doesn't work
            print("url is \(url.absoluteString)")
            //create new opportunity
            let op = Opportunity(name: name, content: description, tag: forWho, link: getURL(), deadline: deadline.ISO8601Format()) //TODO: use correct deadline (with fractional seconds)
            
            let ref = Database.database().reference()
            ref.child("opportunities").child(op.id).setValue(try! op.getDict()) {(error, ref) in
                if let error = error {
                    print("Error adding opportunity! \(error.localizedDescription)")
                } else {
                    print("posted opportunity!")
                }
            }
            
            dismiss()
        } else {
            brokenLink = true
        }
    }
}

struct AddOpportunityView_Previews: PreviewProvider {
    static var previews: some View {
        AddOpportunityView()
    }
}

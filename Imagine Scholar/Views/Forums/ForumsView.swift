//
//  ForumsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/27/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct ForumResponseView: View {
    let forumResponse: ForumResponse
    @State private var quotedResponse: ForumResponse?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text(forumResponse.authorName ?? "Anonymous")
                    .font(.headline)
                Text(forumResponse.getDisplayTime(from: forumResponse.date))
                    .font(.subheadline)
                Text(forumResponse.response)
            }
            
            if let quoted = quotedResponse {
                VStack(alignment: .leading) {
                    Text(quoted.authorName ?? "Anonymous")
                        .font(.headline)
                    Text(quoted.getDisplayTime(from: quoted.date))
                        .font(.subheadline)
                    
                    Text(quoted.response)
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .fill(.gray)
                )
            }
        }.onAppear {
            loadQuotedResponse()
        }
    }
    
    //loads the quoted response if present
    func loadQuotedResponse() {
        if let quotedResponseId = forumResponse.quotedResponse {
            Database.database().reference().child("forums")
            .child("responses").observeSingleEvent(of: .value) {snapshot in
                for child in snapshot.children {
                    if let resData = (child as! DataSnapshot).value as? [String: Any] {
                        let res: ForumResponse = try! ForumResponse.fromDict(dictionary: resData)
                        if res.id == quotedResponseId {
                            quotedResponse = res
                        }
                    } else {
                        print("if check failed")
                    }
                }
            }
        }
    }
    
}

struct ForumsView: View {
    @EnvironmentObject var user: User
    @State private var forum: Forum? = nil
    @State private var quotedResponse: ForumResponse? = nil
    @State private var showingSheet = false
    @State private var anon = false
    @State private var response = ""
    var ref = Database.database().reference().child("forums")
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            if let forum = forum {
                Form {
                    Section {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Question")
                                    .font(.headline)
                                Spacer()
                                Button {
                                    showingSheet = true
                                } label: {
                                    Image(systemName: "purchased.circle.fill")
                                }
                            }
                            Text(forum.question)
                                .padding(.top)
                        }
                    }
                    
                    Section {
                        if let responses = forum.responses {
                            List(responses) {r in
                                ForumResponseView(forumResponse: r)
                                    .onTapGesture {
                                        showingSheet = true
                                        quotedResponse = r
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Forums")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                Button("Post test forum") {
                    
                    //send a test forum
                    let a = Forum(question: "How to best educate society about sexuality?")
                    ref.setValue(try! a.getDict()) {err, _ in
                        if let err = err {
                            print("Error sending forum \(err.localizedDescription)")
                        } else {
                            print("Sent forum!")
                        }
                    }
                }
            }
        }
        .onAppear {
            loadForum()
            listenForUpdates()
        }
        .sheet(isPresented: $showingSheet) {
            if let forum = forum {
                Form {
                    Section {
                        VStack(alignment: .leading) {
                            Text("Question")
                                .font(.headline)
                            Text(forum.question)
                                .padding(.top)
                        }
                    }
                    
                    if let quoted = quotedResponse {
                        Section("\(quoted.authorName ?? "Someone") said") {
                            Text(quoted.response)
                        }
                    }
                    
                    Section("Response") {
                        TextEditor(text: $response)
                        Toggle("Anonymous", isOn: $anon)
                    }
                    
                    Section {
                        Button ("Send") {
                            sendResponse()
                        }
                    }
                    .disabled(response.isEmpty)
                }
            }
        }
    }
    
    //Sends the response
    func sendResponse() {
        if let forum = forum {
            var responses = forum.responses ?? []
            var response = ForumResponse(response: response)
            
            if !anon {
                response.authorURL = user.imageURL
                response.authorName = user.name
            }
            response.quotedResponse = quotedResponse?.id;
            responses.append(response)
            
            //convert each response to a dict
            var resps: [[String:Any]] = []
            for response in responses {
                resps.append(try! response.getDict()!)
            }
            
            ref.child("responses").setValue(resps) {err, _ in
                if let err = err {
                    print("Error adding response! \(err.localizedDescription)")
                } else {
                    print("Successfully added response!")
                }
            }
        }
        
        response = ""
        showingSheet = false
        quotedResponse = nil
        anon = false

    }
    
    //Loads the forum
    func loadForum() {
        ref.observeSingleEvent(of: .value) {snapshot in
            if let forumData = snapshot.value as? [String: Any] {
                let f: Forum = try! Forum.fromDict(dictionary: forumData)
                forum = f
            }
        }
    }
    
    //Updates the forum when it changes
    func listenForUpdates() {
        ref.observe(.value) {snapshot in
            if let forumData = snapshot.value as? [String: Any] {
                let f: Forum = try! Forum.fromDict(dictionary: forumData)
                forum = f
            }
        }
    }
}

struct ForumsView_Previews: PreviewProvider {
    static var previews: some View {
        ForumsView()
    }
}

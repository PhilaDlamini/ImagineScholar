//
//  CreatePostView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/21/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text = ""
    @State private var user: User? = nil
    @State var quotedPost: Post?
    
    var body: some View {
        VStack (alignment: .leading) {
        
            if let user = user {
                
                HStack {
                    
                    AsyncImage(url: user.imageURL) {phase in
                        
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
                    
                    Text(user.name)
                        .font(.headline)
                }
            }
            
            
            TextField("What's going on?", text: $text, axis: .vertical)
                .onSubmit(post)
                
            if let quotedPosted = quotedPost {
                QuotedPostView(post: quotedPosted)
            }
            Spacer()
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Post", action: post)
            }
        }
        .onAppear(perform: {
            if let userData = UserDefaults.standard.data(forKey: "user") {
                if let usr = try? JSONDecoder().decode(User.self, from: userData) {
                    user = usr
                }
            }
        })
    }
    
    func post() {
        let ref = Database.database().reference()
        
        //save the data
        if let user = user {
            let post = Post(author: user.name, authorURL: user.imageURL, content: text,  comments: nil, likes: nil, likedURLs: nil, quotedPostId: quotedPost?.id.uuidString ?? nil)
            
            ref.child("posts").child(post.id.uuidString).setValue(try! post.getDict()) {(error, ref) in
                if let error = error {
                    print("Error posting! \(error.localizedDescription)")
                } else {
                    print("posted!")
                }
            }
        }
            
        dismiss()
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(quotedPost: Post(author: "Phila", authorURL: URL(string: "https://www.google.com")!, content: "Hey haha"))
    }
}


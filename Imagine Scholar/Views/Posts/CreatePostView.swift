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
    @EnvironmentObject var user: User
    @State var quotedPost: Post?
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                    HStack {
                        
                        AsyncImage(url: URL(string: user.imageURL)) {phase in
                            
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
                TextField("What's going on?", text: $text, axis: .vertical)
                    .onSubmit(post)
                
                if let quotedPosted = quotedPost {
                    QuotedPostView(post: quotedPosted)
                }
                Spacer()
                
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        post()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .disabled(text.isEmpty)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func post() {
        let ref = Database.database().reference()
        
        //save the data
        let post = Post(author: user.name, authorURL: user.imageURL, content: text,  comments: nil, likes: nil, likedURLs: nil, quotedPostId: quotedPost?.id ?? nil)
        
        ref.child("posts").child(post.id).setValue(try! post.getDict()) {(error, ref) in
            if let error = error {
                print("Error posting! \(error.localizedDescription)")
            } else {
                print("posted!")
            }
        }
        
        dismiss()
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(quotedPost: Post(author: "Phila", authorURL:  "https://www.google.com", content: "Hey haha"))
    }
}


//
//  PostDetailsView.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/10/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct PostDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @State var post: Post
    @State private var comment = ""
    @State private var user: User? = nil
    @State private var userComment: PostComment? = nil
    @State private var likedBy = ""
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(url: post.authorURL) {phase in
                            
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
                        
                        VStack {
                            Text(post.author)
                                .font(.headline)
                            
                            Text(post.timestamp.formatted(date: .omitted, time: .shortened))
                        }
                        
                    }
                    
                    Text(post.content)
                    
                    if let urls = post.likedURLs {
                        HStack {
                            
                            HStack(spacing:-8) {
                                
                                //Display the images
                                ForEach(urls, id: \.self) {url in
                                    AsyncImage(url: URL(string: url)) {phase in
                                        
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
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
                                }
                            }
                            
                            Text(likedBy)
                                .font(.subheadline)
                        }
                    }
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                        .padding([.top, .bottom])
                    
                    if let comments = post.comments {
                        ForEach(comments) {comment in
                            
                            if let responses = comment.responses {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Circle() //will be async image
                                            .fill(.gray)
                                            .frame(width: 20, height: 20)
                                        Text(comment.author)
                                            .font(.headline)
                                    }
                                    
                                    HStack {
                                        
                                        Rectangle()
                                            .fill(.gray)
                                            .frame(width: 1)
                                            .padding([.leading], 10)
                                        
                                        VStack {
                                            Text(comment.content)
                                                .padding([.leading], 10)
                                            
                                            ForEach(responses) {resp in
                                                normal(author: resp.author, content: resp.content, image: resp.imageURL)
                                            }
                                        }
                                    }
                                }
                                
                            } else {
                                normal(author: comment.author, content: comment.content, image: comment.imageURL)
                            }
                        }
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("Comment", text: $comment)
                Spacer()
                Button {
                    postComment();
                } label: {
                    Image(systemName: "arrow.up.circle")
                }.disabled(comment.isEmpty)
                
            }
            .padding()
            .background(Capsule().fill(.gray.opacity(0.2)))
            .padding()
            
        }
        .onAppear(perform: {
            if let userData = UserDefaults.standard.data(forKey: "user") {
                if let usr = try? JSONDecoder().decode(User.self, from: userData) {
                    user = usr
                }
            }
            
            //figure out the "liked by" text
            if let likes = post.likes {
                
                //Get the first person who liked the post
                Database.database().reference().child("users").child(likes[0]).child("name").observeSingleEvent(of: .value) { snapshot in
                    
                    let firstPerson = snapshot.value as! String
                    
                    if(likes.count == 1) {
                        likedBy = "Liked by \(firstPerson)"
                    } else if (likes.count == 2) {
                        likedBy = "Liked by \(firstPerson) and 1 other"
                    } else {
                        likedBy = "Liked by \(firstPerson) and \(likes.count - 1) other"
                    }
                }
                
                
            }
            
            //attach an observer to monitor changes to this post (TODO: same issue as before: needs to filter comments by id so to avoid duplicates)
            let ref = Database.database().reference()
            ref.child("posts").child(post.id.uuidString).observe(.value) {snapshot in
                for _ in snapshot.children {
                    if let postData = snapshot.value as? [String: Any] {
                        let updatedPost: Post = try! Post.fromDict(dictionary: postData)
//                        for comment in updatedPost.comments
                        post = updatedPost
                        print("should have updated post")
                    }
                }
            }
           
        })
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let user = user {
                if user.imageURL.absoluteString == post.authorURL.absoluteString { //TODO: need a stronger  way to authenticate here
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            deletePost()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
    
    func normal(author: String, content: String, image: URL) -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                
                AsyncImage(url: image) {phase in
                    
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
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                
                Text(author)
                    .font(.headline)
            }
            
            Text(content)
                .padding([.leading], 28)
        }
    }
    
    func postComment() { //comments on a given post
        if let user = user {
            var comments = post.comments ?? []
            userComment = PostComment(author: user.name, imageURL: user.imageURL, content: comment)
            comments.append(userComment!)
            
            //convert each comment to a dictionary
            var coms: [[String:Any]] = []
            for comment in comments {
                coms.append(try! comment.getDict()!)
            }
            
            let ref = Database.database().reference()
            ref.child("posts").child(post.id.uuidString).child("comments").setValue(coms) {err, _ in
                if let err = err {
                    print("Error adding comment! \(err.localizedDescription)")
                } else {
                    print("Successfully added comment!")
                    
                    comment = ""
                    updatePost()
                }
            }
            
        } else {
            print("Failed to load the current user ")
        }
        
    }
    
    //deletes the post
    func deletePost() {
        let ref = Database.database().reference()
        ref.child("posts").child(post.id.uuidString).removeValue()
        dismiss()
    }
    
    //update the current post with the new comment
    func updatePost() {
        var comments = post.comments ?? []
        comments.append(userComment!)
        let newPost = Post(id: post.id, author: post.author, authorURL: post.authorURL, content: post.content,
        comments: comments)
        post = newPost
    }
}

//struct PostDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostDetailsView(post: Post(author: "Megan", authorURL: URL(string: "fake link")!, content: "Hi all, I'm loving this new movie about the business of selling cupcakes. I will be starting my own brownie business so please come along for the love"))
//    }
//}

//
//PostComment(author: "Lucky", authorUID: "someID", content: "I think I love!", responses: [PostCommentResponse(author: "Queen", authorUID: "some ID", content: "I agree!")])  [PostComment(author: "Phila", authorUID: "someID", content: "Oh yes, I love this!", responses: [PostCommentResponse(author: "Queen", authorUID: "some ID", content: "I agree!")])
//, comments: [PostComment(author: "Noxolo", authorUID: "someID", content: "Go off sis! I love a business queen"),  PostComment(author: "Noxolo", authorUID: "someID", content: "Adding another comment becuase this is so cool!")]
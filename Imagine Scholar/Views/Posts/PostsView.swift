//
//  PostsView.swift. Displays all the views
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/21/23.
//

import SwiftUI
import FirebaseDatabase
import Firebase

//Displays the post in the listview
struct PostView: View {
    var post: Post
    @State var quotedPost: Post? = nil
    @EnvironmentObject var user: User
    @State private var creatingPost = false

    var body: some View {
        NavigationLink(destination: PostDetailsView(post: post)) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    AsyncImage(url: URL(string: post.authorURL)) {phase in
                        
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
                    
                    Text(post.author)
                        .font(.headline)
                    Spacer()
                    Text(post.getDisplayTime(from: post.timestamp))
                    
                }
                
                Text(post.content)
                
                if let quotedPost = quotedPost {
                    QuotedPostView(post: quotedPost)
                }
                
                HStack (spacing: 30) {
                    HStack{
                        
                        Button(action: updateLike) {
                            if let likes = post.likes {
                                if(likes.contains(user.uid)) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "heart")
                                }
                            } else {
                                Image(systemName: "heart")
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())//ensures it's clickable in this nav layout
                        
                        Text("\(post.likes?.count ?? 0)")
                    }
                    HStack{
                        Image(systemName: "text.bubble")
                        Text("\(post.comments?.count ?? 0)")
                    }
                    
                    Button {
                        creatingPost = true
                    } label: {
                        Image(systemName: "quote.closing")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
                
            }
        }
        .onAppear(perform: loadQuotedPost)
        .sheet(isPresented: $creatingPost) {
            CreatePostView(quotedPost: post)
        }
    }
    
    //loads the quoted post if present
    func loadQuotedPost() {
        if let quotedPostId = post.quotedPostId {
            let ref = Database.database().reference().child("posts")
            ref.child(quotedPostId).observeSingleEvent(of: .value) {snapshot in
                if let postData = snapshot.value as? [String: Any] {
                    let post: Post = try! Post.fromDict(dictionary: postData)
                    quotedPost = post
                }
            }
        }
    }
    
    
    //updates the like
    func updateLike() {
        var likes = post.likes ?? []
        let ref = Database.database().reference().child("posts")
        
        //Unlike if already liked
        if likes.contains(user.uid) {
            
            likes.removeAll {$0 == user.uid}
            ref.child(post.id).child("likes").setValue(likes) {err, _ in
                if let err = err {
                    print("Error removing like! \(err.localizedDescription)")
                } else {
                    print("Sent like successfully :)")
                }
            }
            
            var likedURLs = post.likedURLs!
            likedURLs.removeAll{$0 == user.imageURL}
            ref.child(post.id).child("likedURLs").setValue(likedURLs) {err, _ in
                if let err = err {
                    print("Error removing author url! \(err.localizedDescription)")
                } else {
                    print("Removed author URL successfully :)")
                }
            }
            
        } else {
            
            //Else, send like
            likes.append(user.uid)
            ref.child(post.id).child("likes").setValue(likes) {err, _ in
                if let err = err {
                    print("Error adding like! \(err.localizedDescription)")
                } else {
                    print("Sent like successfully :)")
                }
            }
            
            var likedURLs = post.likedURLs ?? []
            likedURLs.append(user.imageURL)
            ref.child(post.id).child("likedURLs").setValue(likedURLs) {err, _ in
                if let err = err {
                    print("Error adding url! \(err.localizedDescription)")
                } else {
                    print("Sent authoer URL successfully :)")
                }
            }
        }
    }
}

struct PostsView: View {
    @State private var creatingPost = false
    @State private var posts = [Post]()
    @EnvironmentObject var user: User
    let ref = Database.database().reference().child("posts")

    var body: some View {
        NavigationView {
            List(posts) { post in
                PostView(post: post)
                
            }
            .sheet(isPresented: $creatingPost) {
                CreatePostView(quotedPost: nil)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Image(systemName: "airplane.circle.fill")
                        Text("Posts")
                            .font(.headline)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        creatingPost = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    NavigationLink(destination: OpportunitiesView()) {
                        Label("Ops", systemImage: "o.circle.fill")
                    }
                }
//                ToolbarItem { //TODO: --> remove
//                    Button("log out") {
//                        try! Auth.auth().signOut()
//                        //                        var user = getUser()
//                    }
//                }
            }
            .onAppear{
                attachListeners()
            }
            
        }
    }
    
    //Listens for changes to the post
    func attachListeners() {
        
        //if a new post is added, append it to the list of posts
        ref.observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    let post: Post = try! Post.fromDict(dictionary: postData)
                    if !posts.contains(where: {$0.id == post.id}) {
                        posts.insert(post, at: 0)
                    }
                }
            }
        }
        
        //if a post is updated, update the view
        ref.observe(.childChanged) {snapshot in
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    let post: Post = try! Post.fromDict(dictionary: postData)
                    
                    if let index = posts.firstIndex(where: {$0.id == post.id}) {
                        posts[index] = post
                    }
                }
            }
        }
        
        //if a post is removed, update the view
        ref.observe(.childRemoved) {snapshot in
           if let postData = snapshot.value as? [String: Any] {
               let post: Post = try! Post.fromDict(dictionary: postData)
               posts.removeAll(where: {$0.id == post.id})
               print("Removed post")
            }
        }
    }
}

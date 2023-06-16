//
//  Post.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/21/23.
//

import Foundation
import FirebaseDatabase

struct Post: Identifiable, Codable {
    var id = UUID()
    var author : String
    var authorURL: URL
    var content : String
    var comments: [PostComment]?
    var likes : [String]? //list of uids of users who liked it
    var likedURLs: [String]? //urls of user pics of everyone who liked the image
    var quotedPostId : String?
    var timestamp = Date()
}

struct PostComment: Identifiable, Codable {
    var id = UUID()
    var author: String
    var imageURL: URL
    var content: String
    var responses: [PostCommentResponse]?
}

struct PostCommentResponse: Identifiable, Codable {
    var id = UUID()
    var author: String
    var imageURL: URL
    var content: String
}

//
//  Post.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 5/21/23.
//

import Foundation
import FirebaseDatabase

struct Post: Identifiable, Codable {
    var id = UUID().uuidString
    var author : String
    var authorURL: String
    var content : String
    var comments: [PostComment]?
    var likes : [String]? //list of uids of users who liked it
    var likedURLs: [String]? //urls of user pics of everyone who liked the image
    var quotedPostId : String?
    var timestamp =  {
        let date = Date()
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }()

}

struct PostComment: Identifiable, Codable {
    var id = UUID().uuidString
    var author: String
    var imageURL: String
    var content: String
    var responses: [PostCommentResponse]?
}

struct PostCommentResponse: Identifiable, Codable {
    var id = UUID().uuidString
    var author: String
    var imageURL: String
    var content: String
}

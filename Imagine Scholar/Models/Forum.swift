//
//  Forums.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 7/4/23.
//

import Foundation

struct Forum: Identifiable, Codable {
    var id = UUID().uuidString
    var question: String
    var responses: [ForumResponse]?
}

struct ForumResponse: Identifiable, Codable {
    var id = UUID().uuidString
    var authorName: String?
    var authorURL: String?
    var quotedResponse: String?
    var response: String
    var date =  {
        let date = Date()
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }()

}

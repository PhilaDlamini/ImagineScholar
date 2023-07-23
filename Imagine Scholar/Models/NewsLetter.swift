//
//  NewsLetter.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 7/22/23.
//

import Foundation
import FirebaseDatabase

struct NewsLetter: Identifiable, Codable {
    var id = UUID().uuidString
    var title : String
    var storageURL: String
    var description: String
    var timestamp =  {
        let date = Date()
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }()

}

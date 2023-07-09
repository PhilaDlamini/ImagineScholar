//
//  Codable_JSON.swift
//  Imagine Scholar
//
//  Created by Phila Dlamini on 6/6/23.
//

import Foundation

//Extension added to Codable to allow us to retrive the JSON as a swift dictionary
extension Encodable {
    func getDict() throws -> [String: Any]? {
        if let encoded = try? JSONEncoder().encode(self) {
            if let dict = try? JSONSerialization.jsonObject(with: encoded) as? [String: Any] {
                return dict
            }
        }
        
        return [String: Any]()
    }
    
   static func getIsoTime(from date: Date) -> String {
        let formatter =  ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    func getDisplayTime(from timestamp: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: timestamp)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date!, to: Date.now)
        let seconds = components.second ?? 0
        let minutes = components.minute ?? 0
        let hours = components.hour ?? 0
        let days = components.day ?? 0
        
        if days > 1 {
            return date!.formatted(date: .abbreviated, time: .omitted)
        } else if hours >= 1 {
            return "\(hours) hr"
        } else if minutes >= 1 {
            return "\(minutes) min"
        }
        
        return "\(seconds) sec"
    }
}

extension Decodable {
    static func fromDict<T:Decodable> (dictionary: [String: Any]) throws -> T {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
    }
}

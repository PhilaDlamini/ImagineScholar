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
}

extension Decodable {
    static func fromDict<T:Decodable> (dictionary: [String: Any]) throws -> T {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
    }
}

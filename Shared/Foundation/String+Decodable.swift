//
//  String+Decodable.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/12/21.
//

import Foundation

//decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
extension String {
    func toDecodable<T>(type: T.Type) -> T where T : Decodable {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            fatalError()
        }
        
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(type, from: data) else {
            fatalError()
        }
        
        return result
    }
}

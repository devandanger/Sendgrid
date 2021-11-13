//
//  Data+Decodable.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation

extension Data {
    func toDecodable<T>(type: T.Type) -> T? where T : Decodable {
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: self)
    }
    
    
    func prettyPrint() {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8)
        else {
            print("Pretty: unable to print data")
            return
        }
        
        print("Pretty: \(prettyPrintedString)")
    }
}

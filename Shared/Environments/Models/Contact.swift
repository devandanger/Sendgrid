//
//  Contact.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation

struct Contact: Decodable {
    let firstName: String
    let lastName: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case first = "first_name"
        case last = "last_name"
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .first)
        lastName = try container.decode(String.self, forKey: .last)
        email = try container.decode(String.self, forKey: .email)
    }
}

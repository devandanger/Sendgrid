//
//  ContactList.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Foundation

struct AbbrevContact: Decodable {
    let name: String
    let id: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case count = "contact_count"
        case name
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
        count = try container.decode(Int.self, forKey: .count)
    }
}

struct AbbrevContactList: Decodable {
    let list: [AbbrevContact]
    enum CodingKeys: String, CodingKey {
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode([AbbrevContact].self, forKey: .result)
    }
}

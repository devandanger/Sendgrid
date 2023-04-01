//
//  Template.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation

struct TemplateList: Decodable {
    let list: [Template]
    enum CodingKeys: String, CodingKey {
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        list = try container.decode([Template].self, forKey: .result)
    }
}

struct Template: Decodable {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

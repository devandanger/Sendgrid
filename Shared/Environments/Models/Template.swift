//
//  Template.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/13/21.
//

import Foundation

struct Template: Decodable {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

//
//  DataController.swift
//  Sendgrid (iOS)
//
//  Created by Evan Anger on 3/30/23.
//

import Defaults
import Foundation

struct SendGridProperty: Codable, Defaults.Serializable {
    let name: String
    let apiKey: String
}

extension Defaults.Keys {
    static let dataProperties = Key<[SendGridProperty]>("properties", default: [])
}

class DataController {
    func add(_ property: SendGridProperty) {
        var properties = Defaults[.dataProperties]
        properties.append(property)
        Defaults[.dataProperties] = properties
    }
    
    func remove(by name: String) {
        let properties = Defaults[.dataProperties].filter { $0.name != name }
        Defaults[.dataProperties] = properties
    }
    
    func list() -> [SendGridProperty] {
        let properties = Defaults[.dataProperties]
        return properties
    }
}

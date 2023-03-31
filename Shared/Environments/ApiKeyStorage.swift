//
//  ApiKeyStorage.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Combine
import Defaults
import Foundation
import SwiftUI

class ApiKeyStorage: ObservableObject {
    let dataController = DataController()
    func delete(name: String) {
        dataController.remove(by: name)
    }
    
    func add(name: String, apiKey: String) {
        dataController.add(SendGridProperty(name: name, apiKey: apiKey))
    }
    
    func list() -> [SendGridProperty] {
        return dataController.list()
    }
}

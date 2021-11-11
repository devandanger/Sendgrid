//
//  ApiKeyStorage.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Combine
import Foundation
import SwiftUI

protocol KeyStorage {
    var apiKey: String {
        get
        set
    }
}

class ApiKeyStorage: KeyStorage, ObservableObject {
    @AppStorage("apiKey") var apiKey: String = ""
    
    func delete() {
        apiKey = ""
    }
    
    func add(_ key: String) {
        apiKey = key
    }
}


class MockApiKeyStorage: KeyStorage, ObservableObject {
    var apiKey: String
    init(key: String) {
        self.apiKey = key
    }
    func delete() {}
    func add(_ key: String) {}
}

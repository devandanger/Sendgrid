//
//  ApiKeyStorage.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Foundation

class ApiKeyStorage: ObservableObject {
    var apiKey: String = ""
    var apiKey2: String = "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"
    
    func delete() {
        apiKey2 = ""
    }
    
    func add(_ key: String) {
        apiKey2 = key
    }
}

//
//  SendgridApi.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Foundation
import SwiftUI

typealias ApiResult = (Data?, URLResponse?, Error?) -> Void
class ApiController {
    let storage: ApiKeyStorage
    let baseUrl: String = "https://api.sendgrid.com"
    init(storage: ApiKeyStorage) {
        self.storage = storage
    }

    func customerList(result: @escaping ApiResult) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        

        guard var URL = URL(string: "\(baseUrl)/v3/marketing/lists") else {return}
        let URLParams = [
            "page_size": "100",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        // Headers
        request.addHeaders(key: storage.apiKey)
        

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: result)
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func getTemplates(result: @escaping ApiResult) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        var request = URLRequest.createUrl(action: "v3/templates", query: [
            "generation": "dynamic",
            "page_size": "100"
        ])
        request.httpMethod = "GET"
        request.addHeaders(key: storage.apiKey)
        
        let task = session.dataTask(with: request, completionHandler: result)
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func sendTestEmail(template: String, sender: String, emails: [String], from: String, result: @escaping ApiResult) {
        
    }
    
    func contactList(id listId: String, result: @escaping ApiResult) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        

        guard let URL = URL(string: "\(baseUrl)/v3/marketing/contacts/search") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        let body = """
        { "query": "CONTAINS(list_ids, '\(listId)')"}
        """
        print("Body: \(body)")
        request.httpBody = body.data(using: .utf8)

        // Headers
        request.addHeaders(key: storage.apiKey)

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: result)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

extension URLRequest {
    fileprivate static func createUrl(action: String, query: [String: String] = [:]) -> URLRequest {
        guard var URL = URL(string: "https://api.sendgrid.com") else { fatalError() }
        URL.appendPathComponent(action)
        URL = URL.appendingQueryParameters(query)
        return URLRequest(url: URL)
    }
    fileprivate mutating func addHeaders(key: String) {
        self.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

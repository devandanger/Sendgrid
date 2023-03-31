//
//  SendgridApi.swift
//  Sendgrid
//
//  Created by Evan Anger on 11/11/21.
//

import Foundation
import SwiftUI
import CombineMoya
import Moya


func sendGridEndpoint(with prop: SendGridProperty) -> (SendgridAPI) -> Endpoint {
    let endpoint = { (target: SendgridAPI) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)

        // Sign all non-authenticating requests
        switch target {
        default:
            return defaultEndpoint.adding(
                newHTTPHeaderFields: [
                    "Authorization": "Bearer \(prop.apiKey)",
                                      "Content-Type": "application.json"
                ])
        }
    }
    return endpoint
}

enum SendgridAPI {
    case customers
    case templates
    case sendTest(template: String, from: [String], to: [String])
}

extension SendgridAPI: TargetType {
    var path: String {
        switch self {
        case .customers:
            return "v3/marketing/lists"
        case .templates:
            return "v3/templates"
        case .sendTest(_, _, _):
            return "v3/marketing/test/send_email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .customers:
            return .get
        case .templates:
            return .get
        case .sendTest(_, _, _):
            return .post
        }
    }
    
    var task: Moya.Task {
        return Task.requestPlain
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    public var baseURL: URL {
        return URL(string: "https://api.sendgrid.com")!
    }
}

typealias ApiResult = (Data?, URLResponse?, Error?) -> Void
class ApiController: ObservableObject {
    let provider: MoyaProvider<SendgridAPI>
    let baseUrl: String = "https://api.sendgrid.com"
    @Published var contactList: [AbbrevContact] = []
    
    init(property: SendGridProperty) {
        provider = MoyaProvider<SendgridAPI>(
            endpointClosure: sendGridEndpoint(with: property),
            plugins: [
                NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .formatRequestAscURL))
            ])
    }
    
    public func refresh() {
        refreshCustomerList()
        refreshTemplates()
    }

    private func refreshCustomerList() {
        provider.request(.customers) { result in
            print("Result customer: \(result)")
            
            switch result {
            case .success(let response):
                let result = response.data.toDecodable(type: AbbrevContactList.self)
                self.contactList = result?.list ?? []
            case .failure(_):
                return
            }
        }
    }
    
    private func refreshTemplates() {
        provider.request(.templates) { result in
            print("Result template: \(result)")
        }
    }

//
//    func sendTestEmail(template: String, emails: [String], from: String, result: @escaping ApiResult) {
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//
//        var request = URLRequest.createUrl(action: "v3/marketing/test/send_email")
//        let body = """
//        {
//            "template_id": "\(template)",
//            "emails": [ "devandanger@gmail.com" ],
//            "from_address": "\(from)"
//        """.data(using: .utf8)
//        request.httpBody = body
//        request.httpMethod = "POST"
//        request.addHeaders(key: storage.apiKey)
//
//        let task = session.dataTask(with: request, completionHandler: result)
//        task.resume()
//        session.finishTasksAndInvalidate()
//    }
//
//    func contactList(id listId: String, result: @escaping ApiResult) {
//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//
//
//        guard let URL = URL(string: "\(baseUrl)/v3/marketing/contacts/search") else {return}
//        var request = URLRequest(url: URL)
//        request.httpMethod = "POST"
//
//        let body = """
//        { "query": "CONTAINS(list_ids, '\(listId)')"}
//        """
//        print("Body: \(body)")
//        request.httpBody = body.data(using: .utf8)
//
//        // Headers
//        request.addHeaders(key: storage.apiKey)
//
//        /* Start a new Task */
//        let task = session.dataTask(with: request, completionHandler: result)
//        task.resume()
//        session.finishTasksAndInvalidate()
//    }
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

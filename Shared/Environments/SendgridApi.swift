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
    case getCustomers(listID: String)
    case templates
    case sendTest(senderID: Int, template: String, from: String, to: [String])
    case senders
}

extension SendgridAPI: TargetType {
    var path: String {
        switch self {
        case .customers:
            return "v3/marketing/lists"
        case .getCustomers(_):
            return "v3/marketing/contacts/search"
        case .templates:
            return "v3/templates"
        case .sendTest(_, _, _, _):
            return "v3/marketing/test/send_email"
        case .senders:
            return "v3/verified_senders"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .customers:
            return .get
        case .getCustomers(_):
            return .post
        case .templates:
            return .get
        case .sendTest(_, _, _, _):
            return .post
        case .senders:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .templates:
            return .requestParameters(parameters: ["page_size": 100, "generations": "dynamic"], encoding: URLEncoding())
        case .getCustomers(let listID):
            return .requestParameters(parameters: ["query": "CONTAINS(list_ids, '\(listID)')"], encoding: JSONEncoding())
        case .sendTest(let sender, let template, let fromAddress, let toAddress):
            return .requestParameters(parameters: ["sender_id": sender,"template_id": template, "from_address": fromAddress, "emails": toAddress], encoding: JSONEncoding())
        default:
            return .requestPlain
        }
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
    @Published var templateList: [Template] = []
    @Published var senderList: [Sender] = []

    init(property: SendGridProperty) {
        provider = MoyaProvider<SendgridAPI>(
            endpointClosure: sendGridEndpoint(with: property),
            plugins: [
                NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .formatRequestAscURL))
            ])
    }
    
    public func getContactList(for listID: String, completion: @escaping ([Contact], Error?) -> ()) {
        provider.request(.getCustomers(listID: listID)) { result in
            switch result {
            case .success(let response):
                let result = response.data.toDecodable(type: ContactList.self)
                completion(result?.list ?? [], nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    public func refresh() {
        refreshCustomerList()
        refreshTemplates()
        refreshSenders()
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
            
            switch result {
            case .success(let response):
                let result = response.data.toDecodable(type: TemplateList.self)
                self.templateList = result?.list ?? []
            case .failure(_):
                return
            }
        }
    }
    
    private func refreshSenders() {
        provider.request(.senders) { result in
            switch result {
            case .success(let response):
                let result = response.data.toDecodable(type: ResponseResult<Sender>.self)
                self.senderList = result?.results ?? []
            case .failure(_):
                return
            }
        }
    }


    func sendTestEmail(senderID: Int, template: String, emails: [String], from: String, completion: @escaping (Error?) -> ()) {
        provider.request(.sendTest(senderID: senderID, template: template, from: from, to: emails)) { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(_):
                completion(nil)
            }
        }
        
    }
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

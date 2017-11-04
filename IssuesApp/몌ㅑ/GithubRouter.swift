//
//  GithubRouter.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 11. 4..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubRouter {
    case repoIssues(owner: String, repo: String, parameters: Parameters)
}

extension GitHubRouter: URLRequestConvertible {
    static let baseURLString = "https://api.github.com"
    static let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    
    var method: HTTPMethod {
        switch self {
        case .repoIssues:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .repoIssues(owner, repo, _):
            return "/repos/\(owner)/\(repo)/issues"
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = try GitHubRouter.baseURLString.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method:
            method)
        if let token = GlobalState.instance.token, !token.isEmpty {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "authorization")
        }
        
        switch  self {
        case let .repoIssues(_, _, parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
    
    
}

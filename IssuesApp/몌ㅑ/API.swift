//
//  Api.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 10. 28..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation
import OAuthSwift
import SwiftyJSON
import Alamofire

protocol API {
    typealias IssueResponsesHandler = (DataResponse<[Model.Issue]>) -> Void
    func getToken(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssueResponsesHandler) -> Void
}

struct GitHubAPI: API {
    let oauth =  OAuth2Swift(consumerKey: "dc7db1de744aa3e82a47",
                             consumerSecret: "554a3e9b89f140736050a37e3e37379aa3bc7e39",
                             authorizeUrl: "https://github.com/login/oauth/authorize",
                             accessTokenUrl: "https://github.com/login/oauth/access_token",
                             responseType: "code")
    
    func getToken(handler: @escaping (() -> Void)) {
        oauth.authorize(
            withCallbackURL: "IssuesApp://oauth-callback/github",
            scope: "user, repo",
            state: "state",
            success: { (credential, _, _) in
                GlobalState.instance.token = credential.oauthToken
                GlobalState.instance.refreshToken = credential.oauthRefreshToken
                print("token: \(credential.oauthToken)")
                handler()
        },
            failure:  { error in
                print(error.localizedDescription)
        })
    }
    func tokenRefresh(handler: @escaping (() -> Void)) {
        guard let refreshToken = GlobalState.instance.refreshToken else { return }
        oauth.renewAccessToken(
            withRefreshToken: refreshToken,
            success: { (credential, _, _) in
                GlobalState.instance.token = credential.oauthToken
                GlobalState.instance.refreshToken = credential.oauthRefreshToken
                handler()
        },
            failure: { error in
                print(error.localizedDescription)
        })
    }
    
    typealias IssuesResponseHandler = (DataResponse<[Model.Issue]>) -> Void
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssueResponsesHandler) -> Void {
        let parameters: Parameters = ["page": page, "state": "all"]
        GitHubRouter.manager.request(GitHubRouter.repoIssues(owner: owner, repo: repo, parameters: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            let result: DataResponse<[Model.Issue]> = dataResponse.map({ (json: JSON) -> [Model.Issue] in
                return json.arrayValue.map {
                    Model.Issue(json: $0)
                }
            })
            handler(result)
        }
    }
}

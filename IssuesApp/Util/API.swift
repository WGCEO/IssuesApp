//
//  Api.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 10. 28..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation
import OAuthSwift

protocol API {
    func getToekn(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
}

struct GitHubAPI: API {
    let oauth =  OAuth2Swift(consumerKey: "06eae7a4010c6f263244",
                             consumerSecret: "d2fb81215a65fbc10f6eff4daf31ed8fcbb711e6",
                             authorizeUrl: "https://github.com/login/oauth/authorize",
                             accessTokenUrl: "https://github.com/login/oauth/access_token",
                             responseType: "code")
    
    func getToekn(handler: @escaping (() -> Void)) {
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
}

//
//  GlobalState.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 10. 28..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation

final class GlobalState {
    static let instance = GlobalState()
    
    enum Constants: String {
        case tokenKey
        case refreshTokenKey
        case ownerKey
        case repoKeys
    }
    
    var token: String? {
        get {
            let token = UserDefaults.standard.string(forKey: Constants.tokenKey.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.tokenKey.rawValue)
        }
    }
    var refreshToken: String? {
        get {
            let token = UserDefaults.standard.string(forKey: Constants.refreshTokenKey.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.refreshTokenKey.rawValue)
        }
    }
    
    var owner: String {
        get {
            let owner = UserDefaults.standard.string(forKey: Constants.ownerKey.rawValue) ?? ""
            return owner
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.ownerKey.rawValue)
        }
    }
    
    var repo: String {
        get {
            let owner = UserDefaults.standard.string(forKey: Constants.repoKeys.rawValue) ?? ""
            return owner
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.repoKeys.rawValue)
        }
    }
    
    var isLoggedIn: Bool {
        let isEmpty = token?.isEmpty ?? true
        return !isEmpty
    }
    
    var repos: [(owner: String, repo: String)] {
        let repoDicts: [[String:String]] = UserDefaults.standard.array(forKey: Constants.repoKeys.rawValue) as? [[String : String]] ?? []
        let repos = repoDicts.map { (repoDict: [String: String]) -> (String, String) in
            let owner = repoDict["owner"] ?? ""
            let repo = repoDict["repo"] ?? ""
            return (owner, repo)
        }
        return repos
    }
    
    func addRepo(owner: String, repo: String) {
        let dict = ["owner" : owner, "repo": repo]
        var repos: [[String : String]] = UserDefaults.standard.array(forKey: Constants.repoKeys.rawValue) as? [[String: String]] ?? []
        repos.append(dict)
        
        //중복제거하는 방법: NSSet(array: repos).allObjects
        UserDefaults.standard.set(NSSet(array: repos).allObjects, forKey: Constants.repoKeys.rawValue)
    }
}

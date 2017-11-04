//
//  Model.swift
//  IssuesApp
//
//  Created by changi kim on 2017. 11. 4..
//  Copyright © 2017년 Piano. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Model {
    
}

extension Model {
    struct Issue {
        let id: Int
        let number: Int
        let title: String
        let user: Model.User
        let state: State
        let comments: Int
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        let closedAt: Date?
        
        init(json: JSON) {
            print("issue json: \(json)")
            id = json["id"].intValue
            number = json["number"].intValue
            title = json["title"].stringValue
            user = Model.User(json: json["user"])
            state = State(rawValue: json["state"].stringValue) ?? .open
            comments = json["comments"].intValue
            body = json["body"].stringValue
            
            let format = DateFormatter()
            //T와 Z는 내려올 때 실제로 저 값이 내려져서 오기때문에 적어줘야함(이게 무슨 말?)
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
            closedAt = format.date(from: json["closed_at"].stringValue)
        }
    }
}

extension Model.Issue {
    enum State: String {
        case open
        case closed
    }
}

extension Model {
    struct User {
        let id: String
        let login: String
        let avatarURL: URL?
        
        init(json: JSON) {
            id = json["id"].stringValue
            login = json["login"].stringValue
            avatarURL = URL(string: json["avatar_url"].stringValue)
        }
    }
}


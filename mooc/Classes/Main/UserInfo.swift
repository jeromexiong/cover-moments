//
//  UserInfo.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/16.
//  Copyright © 2020 kilomind. All rights reserved.
//


import SwiftyJSON

class UserInfo: Codable {
    var id: Int = 0
    var topUrl: String!
    var avatar: String!
    var userName: String!
    
    init(_ json: JSON) {
        id = json["id"].intValue
        topUrl = json["headImage"].stringValue
        avatar = json["headAvatar"].stringValue
        userName = json["headUserName"].stringValue
    }
}

extension UserInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self === object else { return true }
        guard let object = object as? UserInfo else { return false }
        return id == object.id
    }
}

extension UserInfo: Equatable {
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.isEqual(toDiffableObject: rhs)
    }
}


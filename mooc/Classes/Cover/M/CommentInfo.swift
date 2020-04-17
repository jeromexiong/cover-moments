//
//  Comment.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/14.
//  Copyright © 2020 kilomind. All rights reserved.
//

import SwiftyJSON

struct CommentInfo: Codable {
    var comment: String = ""
    var person: String = ""
    var user_id: Int = 0
    
    init(_ json: JSON) {
        comment = json["comment"].stringValue
        person = json["person"].stringValue
        user_id = json["user_id"].intValue
    }
}

extension CommentInfo: Equatable {
    static func == (lhs: CommentInfo, rhs: CommentInfo) -> Bool {
        return (lhs.comment == rhs.comment) && (lhs.person == rhs.person)
    }
}

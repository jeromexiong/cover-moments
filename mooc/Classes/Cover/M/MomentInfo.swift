//
//  MomentInfo.swift
//  mooc
//
//  Created by Jerome Xiong on 2020/4/14.
//  Copyright © 2020 kilomind. All rights reserved.
//

import SwiftyJSON

class MomentInfo: Codable {
    var id: Int = 0
    var avatar: String!
    var userName: String!
    var content: String!
    var location: String!
    var publicTime: String!
    var images: [String] = []
    var comments: [CommentInfo] = []
    var userInfo: UserInfo?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        avatar = json["avatar"].stringValue
        userName = json["userName"].stringValue
        content = json["content"].stringValue
        location = json["location"].stringValue
        publicTime = json["publicTime"].stringValue
        images = json["limage"].stringValue.split(separator: ",").map({String($0)})
        if let _ = json["headImage"].string {
            userInfo = UserInfo(json)
        }
        var list = [CommentInfo]()
        for (_, sub) in json["comments"] {
            var info = CommentInfo(sub)
            info.user_id = Int(arc4random_uniform(255))
            list.append(info)
        }
        comments = list
    }
    
    var cellHeight: CGFloat {
        var cellHeight: CGFloat = 20 + 10
        
        if !content.isEmpty {
            let size = content.textSize(MomentHeaderCell.contentW, font: UIFont.systemFont(ofSize: 17))
            cellHeight += size.height
        }
        
        if images.count > 0 {
            cellHeight += 10
            cellHeight += momentPicsHeight(images.count)
        }

        return cellHeight
    }
    
    func momentPicsHeight(_ picCount: Int) -> CGFloat {
        let verticalSpace: CGFloat = 5
        if picCount == 1 {
            return mImageW * 2 + verticalSpace
        }
        if picCount <= 3 {
            return mImageW + 2 * verticalSpace
        }
        if picCount <= 6 {
            return 2 * mImageW + 3 * verticalSpace
        }
        return 3 * mImageW + 4 * verticalSpace
    }
    var thumbsHeight: CGFloat {
        let verticalSpace: CGFloat = 5
        let rows = comments.count / 7 + (comments.count % 7 > 0 ? 1 : 0)
        let vertical = CGFloat(rows+1)*verticalSpace
        return CGFloat(rows) * CommentThumbView.itemWidth + vertical
    }
    var commentHeight: CGFloat {
        return CGFloat(comments.count * 50)
    }
}

extension MomentInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self === object else { return true }
        guard let object = object as? MomentInfo else { return false }
        return id == object.id
    }
}

extension MomentInfo: Equatable {
    static func == (lhs: MomentInfo, rhs: MomentInfo) -> Bool {
        return lhs.isEqual(toDiffableObject: rhs)
    }
}

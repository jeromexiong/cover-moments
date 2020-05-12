//
//  JXLabelType.swift
//
//  Created by JeromeXiong on 2018/1/24.
//  Copyright © 2018年 JeromeXiong. All rights reserved.
//

import UIKit

/* 枚举关联值 */
public enum JXElements{
    case hashtag(String)
    case mention(String)
    case URL(String)
    case phone(String)
    case custom(String)
    
    static func creat(with type : JXLabelType, text : String) -> JXElements {
        switch type {
        case .hashtag   :return hashtag(text)
        case .mention   :return mention(text)
        case .URL       :return URL(text)
        case .phone     :return phone(text)
        case .custom    :return custom(text)
        }
    }
}
public struct JXLabelRegex {
    static let hashtagPattern = "#.*?#"
    static let mentionPattern = "@[\\p{L}0-9_]*"
    static let URLPattern = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
    static let phonePattern = "400[0-9]{7}|1[34578]\\d{9}$|0[0-9]{2,3}-[0-9]{8}"
    
    static func getMatches(type: JXLabelType, from textString: String, range: NSRange) -> [NSTextCheckingResult]{
        let pattern = type.pattern
        let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        let matches = regex.matches(in: textString, options: [], range: range)
        
        return matches
    }
}
public enum JXLabelType {
    /// #话题#
    case hashtag
    /// @用户名
    case mention
    /// URL
    case URL
    /// 400正则)|(800正则)|(手机号)|(座机号)|
    case phone
    
    case custom(pattern: String, start: Int, tender: Int)
    
    var pattern : String {
        switch self {
        case .hashtag   : return JXLabelRegex.hashtagPattern
        case .mention   : return JXLabelRegex.mentionPattern
        case .URL       : return JXLabelRegex.URLPattern
        case .phone     : return JXLabelRegex.phonePattern
        case .custom(let pattern, _, _) : return pattern
        }
    }
    /// 长度减少
    var tenderLength: Int {
        switch self {
        case .hashtag           : return -2
        case .mention           : return -1
        case .URL, .phone       : return 0
        case .custom(_, _, let tender)  : return tender
        }
    }
    /// 相对起始位置
    var startIndex: Int {
        switch self {
        case .URL, .phone:
            return 0
        case .mention, .hashtag:
            return 1
        case .custom(_, let start, _):
            return start
        }
    }
    
}

extension JXLabelType : Hashable, Equatable {
    public var hashValue : Int {
        switch self {
        case .hashtag   : return -3
        case .mention   : return -2
        case .URL       : return -1
        case .phone     : return -4
        case .custom(let pattern, _, _) : return pattern.hashValue
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .hashtag   : hasher.combine(-3)
        case .mention   : hasher.combine(-2)
        case .URL       : hasher.combine(-1)
        case .phone     : hasher.combine(-4)
        case .custom(let pattern, _, _) : hasher.combine(pattern)
        }
    }
    
    public static func == (lhs: JXLabelType, rhs: JXLabelType) -> Bool {
        
        switch (lhs, rhs) {
        case (.mention, .mention): return true
        case (.hashtag, .hashtag): return true
        case (.URL, .URL): return true
        case (.phone, .phone): return true
        case (.custom(let pattern1, _, _), .custom(let pattern2, _, _)): return pattern1 == pattern2
        default: return false
        }
    }
}

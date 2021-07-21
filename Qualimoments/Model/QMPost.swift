//
//  NewsItem.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/18/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class QMPost: NSObject {
    var id = ""
    var tags: [Any] = []
    var likesCount = 0
    var commentsCount = 0
    var desc = ""
    var picture = ""
    var mark = false
    var liked = false
    var createdAt = 0
    var updatedAt = 0
    var owner = QMUser()
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String                  { id = val }
        if let val = dict["tags"] as? [Any] {
            tags = []
            for tag in val {
                tags.append(tag as! [String: String])
                
            }
        }
        if let val = dict["likesCount"] as? Int             { likesCount = val }
        if let val = dict["commentsCount"] as? Int          { commentsCount = val }
        if let val = dict["description"] as? String         { desc = val }
        if let val = dict["picture"] as? String             { picture = val }        
        if let val = dict["mark"] as? Bool                  { mark = val }
        if let val = dict["liked"] as? Bool                 { liked = val }
        if let val = dict["createdAt"] as? Int              { createdAt = val }
        if let val = dict["updatedAt"] as? Int              { updatedAt = val }
        if let val = dict["owner"] as? NSDictionary         { owner = QMUser.init(dict: val) }
    }
}

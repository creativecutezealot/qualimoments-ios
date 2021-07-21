//
//  QMNewsFeed.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/12/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation

class QMNewsFeed: NSObject {
    var id = ""
    var type = ""
    var post = QMPost()
    var review = QMReview()
    var createdAt = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String                  { id = val }
        if let val = dict["type"] as? String                { type = val }
        if let val = dict["post"] as? [String: Any]         { post = QMPost(dict: val)}
        if let val = dict["review"] as? [String: Any]       { review = QMReview(dict: val)}
        if let val = dict["createdAt"] as? Int              { createdAt = val }
    }
}



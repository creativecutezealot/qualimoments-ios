//
//  QMMessage.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/22/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class QMMessage: NSObject {
    
    var id = ""
    var title = ""
    var picture = ""
    var unread = false
    var updatedAt = 0
    
    override init() {
        super.init()
    }
    
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String              { id = val }
        if let val = dict["title"] as? String           { title = val }
        if let val = dict["picture"] as? String         { picture = val }
        if let val = dict["unread"] as? Bool            { unread = val}
        if let val = dict["updatedAt"] as? Int          { updatedAt = val }
        
    }
}

//
//  QNotification.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/4/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class QNotification: NSObject {
    
    var id = ""
    var from = [String]()
    var title = ""
    var body = ""
    var createdAt: Int64 = 0
   
    
    override init() {
        super.init()
    }
    
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String              { id = val }
        if let val = dict["bodyLocArgs"] as? [String]   { from = val }
        if let val = dict["titleLocKey"] as? String     { title = val }
        if let val = dict["bodyLocKey"] as? String      { body = val}
        if let val = dict["createdAt"] as? Int64        { createdAt = val }
    }
}

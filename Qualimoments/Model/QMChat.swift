//
//  QMChat.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/8.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMChat: NSObject {
    
    var id = ""
    var from = QMProfile()
    var text = ""
    var incoming = false
    var read = false
    var createdAt = 0
    var place = QMPlace()
    var sent = true
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String              { id = val }
        if let val = dict["from"] as? [String: Any]     { from = QMProfile(dict: val) }
        if let val = dict["text"] as? String            { text = val }
        if let val = dict["incoming"] as? Bool          { incoming = val}
        if let val = dict["read"] as? Bool              { read = val }
        if let val = dict["createdAt"] as? Int          { createdAt = val }
        if let val = dict["place"] as? [String: Any]    { place = QMPlace(dict: val) }
    }
}

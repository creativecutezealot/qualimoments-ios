//
//  QMMyReview.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/7.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMMyReview: NSObject {
    
    var id = ""
    var review = ""
    var value1 = false
    var value2 = false
    var value3 = false
    var value4 = false
    var value5 = false
    var value6 = false
    var profile = QMProfile()
    var createdAt = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        
        if let val = dict["id"] as? String                { id = val }
        if let val = dict["review"] as? String            { review = val }
        if let val = dict["value1"] as? Bool              { value1 = val }
        if let val = dict["value2"] as? Bool              { value2 = val }
        if let val = dict["value3"] as? Bool              { value3 = val }
        if let val = dict["value4"] as? Bool              { value4 = val }
        if let val = dict["value5"] as? Bool              { value5 = val }
        if let val = dict["value6"] as? Bool              { value6 = val }
        if let val = dict["profile"] as? [String: Any]    { profile = QMProfile(dict: val) }
        if let val = dict["createdAt"] as? Int            { createdAt = val }
        
        
    }
}

class QMProfile: NSObject {
    var id = ""
    var picture = ""
    var name = ""
    var type = ""
    var updatedAt = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String                { id = val }
        if let val = dict["picture"] as? String           { picture = val }
        if let val = dict["name"] as? String              { name = val }
        if let val = dict["type"] as? String              { type = val }
        if let val = dict["updatedAt"] as? Int            { updatedAt = val }
    }
}

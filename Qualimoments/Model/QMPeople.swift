//
//  QMPeople.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/4/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class QMPeople: NSObject {
    
    var id = ""
    var name = ""
    var externalEmail = ""
    var externalId = ""
    var desc = ""
    var provider = ""
    var mutualFriends = 0
    var type = ""
    var picture = ""
    var createdAt = 0
    var updatedAt = 0
    var connected = false
    var isSelected = false
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String                  { id = val }
        if let val = dict["name"] as? String                { name = val }
        if let val = dict["externalEmail"] as? String       { externalEmail = val }
        if let val = dict["externalId"] as? String          { externalId = val }
        if let val = dict["provider"] as? String            { provider = val }
        if let val = dict["mutualFriends"] as? Int          { mutualFriends = val }
        if let val = dict["description"] as? String         { desc = val }
        if let val = dict["type"] as? String                { type = val }
        if let val = dict["picture"] as? String             { picture = val }
        if let val = dict["createdAt"] as? Int              { createdAt = val }
        if let val = dict["updatedAt"] as? Int              { updatedAt = val }
    }
}

//
//  QMUser.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/4/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class QMUser: NSObject {
    
    var id = ""
    var name = ""
    var provider = ""
    var friendsCount = 0
    var toursCount = 0
    var reviewsCount = 0
    var postsCount = 0
    var newMessagesCount = 0
    var picture = ""
    var createdAt = 0
    var updatedAt = 0
    var type = ""
    var desc = ""
    var externalEmail = ""
    var externalId = ""
    var city = QMCity()
    var connected = false
    
    override init() {
        super.init()
    }
    
    init(dict: NSDictionary) {
        if let val = dict["id"] as? String             { id = val }
        if let val = dict["name"] as? String           { name = val }
        if let val = dict["provider"] as? String       { provider = val }
        if let val = dict["friendsCount"] as? Int      { friendsCount = val }
        if let val = dict["toursCount"] as? Int        { toursCount = val }
        if let val = dict["reviewsCount"] as? Int      { reviewsCount = val }
        if let val = dict["newMessagesCount"] as? Int  { newMessagesCount = val }
        if let val = dict["postsCount"] as? Int        { postsCount = val }
        if let val = dict["picture"] as? String        { picture = val }
        if let val = dict["createdAt"] as? Int         { createdAt = val }
        if let val = dict["updatedAt"] as? Int         { updatedAt = val }
        if let val = dict["type"] as? String           { type = val }
        if let val = dict["description"] as? String    { desc = val }
        if let val = dict["externalEmail"] as? String  { externalEmail = val }
        if let val = dict["externalId"] as? String     { externalId = val }
        if let val = dict["connected"] as? Bool        { connected = val }
        if let val = dict["city"] as? NSDictionary     { city = QMCity(dict: val)}
    }
}

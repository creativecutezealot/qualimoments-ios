//
//  QMFriend.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/4/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class QMSearchedPeople: NSObject {
    
    var id = ""
    var name = ""
    var picture = ""
    var connected = false
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String              { id = val }
        if let val = dict["name"] as? String            { name = val }
        if let val = dict["picture"] as? String         { picture = val }
        if let val = dict["isConnected"] as? Bool       { connected = val }
    }
}

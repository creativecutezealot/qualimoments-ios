//
//  QMSystem.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/6.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMSystem: NSObject {
    
    var name = ""
    var icon = ""
    var site = ""
    var placeId = ""
    var rating: Double = 0
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        
        if let val = dict["name"] as? String                { name = val }
        if let val = dict["icon"] as? String                { icon = val }
        if let val = dict["site"] as? String                { site = val }
        if let val = dict["placeId"] as? String             { placeId = val }
        if let val = dict["rating"] as? Double              { rating = val }
        
        
    }
}

//
//  QMPlacePhoto.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/2/22.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMPlacePhoto: NSObject {
    
    var type = ""
    var content = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["type"] as? String                  { type = val }
        if let val = dict["content"] as? String               { content = val }
    }
}

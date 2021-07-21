//
//  CategoryItem.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/14/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
class CategoryItem: NSObject {
    var id = ""
    var name = ""
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String                  { id = val }
        if let val = dict["name"] as? String                { name = val }
    }
}

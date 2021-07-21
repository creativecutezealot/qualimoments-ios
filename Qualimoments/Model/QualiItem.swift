//
//  QualiItem.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/15/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation

class QualiItem: NSObject {
    
    var rank = ""
    var title = ""
    var desc = ""
    var city = ""
    var score = ""
    
    override init() {
        super.init()
    }
    
    init(rank: String, title: String, desc: String, city: String, score: String) {
        self.rank =     rank
        self.title =    title
        self.desc =     desc
        self.city =     city
        self.score =    score
    }
}

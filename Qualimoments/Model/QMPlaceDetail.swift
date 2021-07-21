//
//  QMPlaceDetail.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/7.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMPlaceDetail: NSObject {
    
    var place = QMPlace()
    var myReview = QMMyReview()
    var city = QMCity()
    var category = CategoryItem()
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        
        if let val = dict["place"] as? [String: Any]                { place = QMPlace(dict: val) }
        if let val = dict["myReview"] as? [String: Any]             { myReview = QMMyReview(dict: val) }
        if let val = dict["city"] as? [String: Any]                 { city = QMCity(dict: val as NSDictionary) }
        if let val = dict["category"] as? [String: Any]             { category = CategoryItem(dict: val) }
    }
}

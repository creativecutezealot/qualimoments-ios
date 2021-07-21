//
//  QMReviewedPlace.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/2/26.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMReviewedPlace: NSObject {
    
    var id = ""
    var name = ""
    var desc = ""
    var address = ""
    var phoneNumber = ""
    var lat: Double = 0
    var lng: Double = 0
    var rating: Double = 0
    var photo = QMPlacePhoto()
    var city = QMCity()
    var category = CategoryItem()
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        
        if let val = dict["id"] as? String                  { id = val }
        if let val = dict["name"] as? String                { name = val }
        if let val = dict["description"] as? String         { desc = val }
        if let val = dict["address"] as? String             { address = val }
        if let val = dict["phoneNumber"] as? String         { phoneNumber = val }
        if let val = dict["lat"] as? Double                 { lat = val }
        if let val = dict["lng"] as? Double                 { lng = val }
        if let val = dict["rating"] as? Double              { rating = val }
        if let val = dict["photo"] as? [String: Any]        { photo = QMPlacePhoto(dict: val) }
        if let val = dict["city"] as? NSDictionary          { city = QMCity(dict: val) }
        if let val = dict["category"] as? [String: Any]     { category = CategoryItem(dict: val) }
    }
}

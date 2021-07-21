//
//  QMReview.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/2/22.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMReview: NSObject {
    
    var id = ""
    var reviewerRating: Double = 0
    var reviewLikes = 0
    var review = ""
    var reviewer = QMUser()
    var liked = false
    var place = QMReviewedPlace()
    
    override init() {
        super.init()
    }
    
    init(dict: [String:Any]) {
        if let val = dict["id"] as? String                  { id = val }
        if let val = dict["reviewerRating"] as? Double      { reviewerRating = val }
        if let val = dict["reviewLikes"] as? Int            { reviewLikes = val }
        if let val = dict["review"] as? String              { review = val }
        if let val = dict["reviewer"] as? NSDictionary      { reviewer = QMUser(dict: val) }
        if let val = dict["liked"] as? Bool                 { liked = val }
        if let val = dict["place"] as? [String: Any]        { place = QMReviewedPlace(dict: val) }
    }
}

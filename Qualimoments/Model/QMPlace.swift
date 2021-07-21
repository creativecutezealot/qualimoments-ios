//
//  QMPlace.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/6.
//  Copyright © 2019 Techtify. All rights reserved.
//

import Foundation
class QMPlace: NSObject {
    
    var id = ""
    var name = ""
    var desc = ""
    var address = ""
    var phoneNumber = ""
    var rating: Double = 0
    var lat: Double = 0
    var lng: Double = 0
    var intRating: Int = 0
    var extOtherRating: Double = 0
    var extExpertRating: Double = 0
    var createdAt: Int = 0
    var updatedAt: Int = 0
    var filled = false
    var photos = [QMPlacePhoto]()
    var systems = [QMSystem]()
    
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
        if let val = dict["intRating"] as? Int              { intRating = val }
        if let val = dict["extOtherRating"] as? Double      { extOtherRating = val }
        if let val = dict["extExpertRating"] as? Double     { extExpertRating = val }
        if let val = dict["createdAt"] as? Int              { createdAt = val }
        if let val = dict["updatedAt"] as? Int              { updatedAt = val }
        if let val = dict["filled"] as? Bool                { filled = val }
        
        if let val = dict["photos"] as? [Any] {
            photos = []
            for p in val {
                let photo = QMPlacePhoto(dict: p as! [String: Any])
                photos.append(photo)
            }
        }
        
        if let val = dict["systems"] as? [Any] {
            systems = []
            for sys in val {
                let system = QMSystem(dict: sys as! [String: Any])
                systems.append(system)
            }
        }
    }
}

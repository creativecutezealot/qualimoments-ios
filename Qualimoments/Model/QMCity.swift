//
//  QMCity.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/23/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation

class QMCountry: NSObject {
    var id: String = ""
    var iso: String = ""
    var name: String = ""
    
    override init() {
        super.init()
    }
    
    init(dict: NSDictionary) {
        if let val = dict["id"] as? String             { id = val }
        if let val = dict["name"] as? String           { name = val }
        if let val = dict["iso"] as? String            { iso = val }
    }
}

class QMCity: NSObject {
    var id = ""
    var country = QMCountry()
    var name = ""
    var lat: Double = 0
    var lng: Double = 0
    var population: Int = 0
    var getnLat: Double = 0
    var getnLng: Double = 0
    var getsLat: Double = 0
    var getsLng: Double = 0
    var isSelected = false
    
    override init() {
        super.init()
    }
    
    init(dict: NSDictionary) {
        if let val = dict["id"] as? String             { id = val }
        if let val = dict["country"] as? NSDictionary  { country = QMCountry.init(dict: val)}
        if let val = dict["name"] as? String           { name = val }
        if let val = dict["lat"] as? Double            { lat = val }
        if let val = dict["lng"] as? Double            { lng = val }
        if let val = dict["population"] as? Int        { population = val }
        if let val = dict["getnLat"] as? Double        { getnLat = val }
        if let val = dict["getnLng"] as? Double        { getnLng = val }
        if let val = dict["getsLat"] as? Double        { getsLat = val }
        if let val = dict["getsLng"] as? Double        { getsLng = val }
    }
    
    func getDict() -> [String: Any] {
        let dict = [
            "id": self.id,
            "country": [
                "id": self.country.id,
                "name": self.country.name,
                "iso": self.country.iso
            ],
            "name": self.name,
            "lat": self.lat,
            "lng": self.lng,
            "population": self.population,
            "getnLat": self.getnLat,
            "getnLng": self.getnLng,
            "getsLat": self.getsLat,
            "getsLng": self.getsLng
            ] as [String : Any]
        
        return dict
    }
}

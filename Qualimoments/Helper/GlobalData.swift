//
//  GlobalData.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/14/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation

class GlobalData {
    static var title = ""
    static var childTitle = ""
    static var top10Type = ""
    
    static var navCount = 1
    
    static var accessToken = ""
    static var refreshToken = ""
    
    static var curUser = QMUser()
    
    static var fcmToken = ""
    
    static var curCity = QMCity()
    
    static var selectedTours: [QMCity] = []
    
    static var myTours: [QMCity] = []
    
    static var selectedCategory = CategoryItem()
    
    static var selectedCity = QMCity()
    
}

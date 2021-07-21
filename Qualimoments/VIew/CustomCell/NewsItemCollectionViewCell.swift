//
//  NewsItemCollectionViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/18/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class NewsItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgChallenge: UIImageView!
    @IBOutlet weak var lblLikeCnt: UILabel!
    @IBOutlet weak var lblRecommendCnt: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
}

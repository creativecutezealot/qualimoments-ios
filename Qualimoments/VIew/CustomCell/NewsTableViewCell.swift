//
//  NewsTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/18/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLikesCount: UILabel!
    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

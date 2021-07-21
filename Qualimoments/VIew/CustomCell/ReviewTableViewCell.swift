//
//  ReviewTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/2/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFeature: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserRated: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

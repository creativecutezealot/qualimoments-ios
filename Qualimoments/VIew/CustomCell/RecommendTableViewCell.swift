//
//  RecommendTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/2/27.
//  Copyright © 2019 Techtify. All rights reserved.
//

import UIKit

class RecommendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvartar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnRecommend: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  ToursTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/24/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class ToursTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

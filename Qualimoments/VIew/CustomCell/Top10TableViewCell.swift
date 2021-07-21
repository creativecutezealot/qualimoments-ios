//
//  Top10TableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/14/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class Top10TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

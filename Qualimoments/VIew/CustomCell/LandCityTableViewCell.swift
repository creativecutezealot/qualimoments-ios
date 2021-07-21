//
//  LandCityTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/15/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class LandCityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

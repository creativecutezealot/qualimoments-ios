//
//  NewMsgTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/22/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class NewMsgTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

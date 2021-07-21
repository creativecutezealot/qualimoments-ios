//
//  PeopleConnectTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/4/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class PeopleConnectTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnConnect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

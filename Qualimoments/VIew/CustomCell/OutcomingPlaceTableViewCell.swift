//
//  OutcomingPlaceTableViewCell.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/8.
//  Copyright © 2019 Techtify. All rights reserved.
//

import UIKit

class OutcomingPlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView() {
        bubbleView.clipsToBounds = true
        bubbleView.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            bubbleView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }

}

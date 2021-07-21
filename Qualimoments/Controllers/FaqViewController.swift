//
//  FaqViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/16/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congigureView()
    }
    
    func congigureView() {
        lblTitle.text = NSLocalizedString("faq", comment: "")
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

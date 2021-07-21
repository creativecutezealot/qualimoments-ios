//
//  BugReportViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/16/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class BugReportViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtBug: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        lblTitle.text = NSLocalizedString("bugReport", comment: "")
        txtBug.placeholder = NSLocalizedString("pleaseEnterBug", comment: "")
        btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
        
        txtBug.layer.borderWidth = 1
        txtBug.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

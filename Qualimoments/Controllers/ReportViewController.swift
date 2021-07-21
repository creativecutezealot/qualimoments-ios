//
//  ReportViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/2/26.
//  Copyright © 2019 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class ReportViewController: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgReportPost: UIImageView!
    @IBOutlet weak var imgReportUser: UIImageView!
    
    @IBOutlet weak var msgConView: UIView!
    @IBOutlet weak var txtMsg: UITextView!
    
    var status = -1
    
    var post: QMPost!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        configureView()
    }
    
    func configureView() {
        msgConView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkReportPost(_ sender: Any) {
        status = 1
        imgReportPost.image = UIImage(named: "check-on")
        imgReportUser.image = UIImage(named: "check-off")
    }
    
    @IBAction func checkReportUser(_ sender: Any) {
        status = 2
        imgReportPost.image = UIImage(named: "check-off")
        imgReportUser.image = UIImage(named: "check-on")
    }
    
    @IBAction func onSend(_ sender: Any) {
        if status == -1 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select report option")
            return
        }
        
        if txtMsg.text.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please write report message.")
            return
        }
        
        var body = [
            "informerId": GlobalData.curUser.id,
            "description": txtMsg.text!
        ]
        
        if status == 1 {
            body["postId"] = post.id
        } else {
            body["violatorId"] = post.owner.id
        }
        
        KVNProgress.show(withStatus: "", on: view)
        APIManager.sharedInstance.postReport(body: body, completion: {
            error, object in
            if error == nil {
                let obj = object as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        let status = err!["status"] as! Int
                        if status == 401 {
                            KVNProgress.dismiss()
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                        }
                        else {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                        }
                        
                        return
                    }
                    
                    KVNProgress.showSuccess()
                    self.dismiss(animated: true, completion: nil)
                }
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription, on: self.view)
            }
        })
    }
}

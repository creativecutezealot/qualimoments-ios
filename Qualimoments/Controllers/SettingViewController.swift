//
//  SettingViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/5/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var lblNotifications: UILabel!
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnNotificationSound: UIButton!
    
    @IBOutlet weak var lblFeedbackSupport: UILabel!
    @IBOutlet weak var btnSendFeedback: UIButton!
    @IBOutlet weak var btnSendBug: UIButton!
    @IBOutlet weak var btnFaq: UIButton!
    
    @IBOutlet weak var lblLegal: UILabel!
    @IBOutlet weak var btnPrivacy: UIButton!
    @IBOutlet weak var btnLicense: UIButton!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        lblNotifications.text = NSLocalizedString("notifications1", comment: "")
        btnSubscribe.setTitle(NSLocalizedString("subscribeToTheQualinews", comment: ""), for: .normal)
        btnNotificationSound.setTitle(NSLocalizedString("notificationSound", comment: ""), for: .normal)
        
        lblFeedbackSupport.text = NSLocalizedString("feedbackAndSupport", comment: "")
        btnSendFeedback.setTitle(NSLocalizedString("sendFeedback", comment: ""), for: .normal)
        btnSendBug.setTitle(NSLocalizedString("sendBugReport", comment: ""), for: .normal)
        btnFaq.setTitle(NSLocalizedString("faq", comment: ""), for: .normal)
        
        lblLegal.text = NSLocalizedString("legal", comment: "")
        btnPrivacy.setTitle(NSLocalizedString("privacyPolicy", comment: ""), for: .normal)
        btnLicense.setTitle(NSLocalizedString("openSourceLicense", comment: ""), for: .normal)
        
        btnLogout.setTitle(NSLocalizedString("logout1", comment: ""), for: .normal)
    }
    
    @IBAction func onSubscribeQulaiNews(_ sender: Any) {
        
    }
    
    @IBAction func onNotificationSound(_ sender: Any) {
    }
    
    @IBAction func onSendFeedBack(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-send-feedback"), object: nil)
    }
    
    @IBAction func onSendBugReport(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-bug-report"), object: nil)
    }
    
    @IBAction func onFaq(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-faq"), object: nil)
    }
    
    @IBAction func onPrivacyPolicy(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-privacy"), object: nil)
    }
    
    @IBAction func onOpenSourceLicences(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-lisence"), object: nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
    }
    
}

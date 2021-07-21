//
//  MenuViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/11/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress
class MenuViewController: UIViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var lblHome: UILabel!
    @IBOutlet weak var lblNewsFeed: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblNotifications: UILabel!
    @IBOutlet weak var lblNetwork: UILabel!
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblLogout: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }   
    
    func configureView() {
        self.imgAvatar.kf.setImage(with: URL(string: GlobalData.curUser.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        self.lblName.text = GlobalData.curUser.name
        if GlobalData.curUser.type == "newbie" {
            self.lblType.text = " \(NSLocalizedString("newbie", comment: "")) "
            self.lblType.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
        } else {
            self.lblType.text = " \(GlobalData.curUser.type) "
            self.lblType.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
        }
        
        lblHome.text = NSLocalizedString("home", comment: "")
        lblNewsFeed.text = NSLocalizedString("newsFeed", comment: "")
        lblMessage.text = NSLocalizedString("messages", comment: "")
        lblNotifications.text = NSLocalizedString("notifications", comment: "")
        lblNetwork.text = NSLocalizedString("network", comment: "")
        lblSettings.text = NSLocalizedString("settings", comment: "")
        lblSearch.text = NSLocalizedString("searchPage", comment: "")
        lblLogout.text = NSLocalizedString("logout", comment: "")
    }
    
    @IBAction func onHome(_ sender: Any) {
        revealViewController().revealToggle(nil)        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-home"), object: nil)
    }
    
    @IBAction func onNews(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-news"), object: nil)
    }
    
    @IBAction func onMessages(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-messages"), object: nil)
    }
    
    @IBAction func onNotifications(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-notifications"), object: nil)
    }
    
    @IBAction func onNetwork(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-network"), object: nil)
    }
    
    @IBAction func onSettings(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-settings"), object: nil)
    }
    
    @IBAction func onSearch(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-search"), object: nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        revealViewController().revealToggle(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
    }
}

//
//  NotificationsViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/12/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
//    0: like, 1: review 2: comment, 3: follow
    var qNotifications:[QNotification] = []
    var nextPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotifications(page: nextPage, limit: 20)
    }
    
    func getNotifications(page: Int = 0, limit: Int = 0) {
        if page == 0 {
            KVNProgress.show()
        }
        
        APIManager.sharedInstance.getNotifications(page: page, limit: limit, completion: {
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
                    
                    let result = object as! NSDictionary
                    if page == 0 {
                        self.qNotifications = []
                    }
                    
                    let notifications = result["messages"] as! [Any]
                    for notification in notifications {
                        let qNotification = QNotification.init(dict: notification as! [String: Any])
                        self.qNotifications.append(qNotification)
                    }
                    
                    if notifications.count > 0 {
                        self.tableView.reloadData()
                        self.nextPage += 1
                    }
                }
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func getTime(timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp)/1000)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm dd.MM.yy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as! NotificationTableViewCell
        let notification = qNotifications[indexPath.row]
//
        if notification.title == Constants.NOTIFICATION_LIKE {
            cell.imgCategory.image = UIImage(named: "liked")
            cell.lblUserName.text = notification.from[0]
            cell.lblContent.text = "liked"
        }
        else if notification.title == Constants.NOTIFICATION_REVIEW {
            cell.imgCategory.image = UIImage(named: "reviewed")
            cell.lblUserName.text = NSLocalizedString("notification_new_review_title", comment: "")//notification.from
            cell.lblContent.text = String(format: NSLocalizedString("notification_new_review_body", comment: ""), notification.from[0], notification.from[1])
        }
        else if notification.title == Constants.NOTIFICATION_NEW_POST {
            cell.imgCategory.image = UIImage(named: "camera-blue")
            cell.lblUserName.text = NSLocalizedString("notification_new_post_title", comment: "")//notification.from[0]
            cell.lblContent.text = String(format: NSLocalizedString("notification_new_post_body", comment: ""), notification.from[0])
        }
        else if notification.title == Constants.NOTIFICATION_FOLLOW {
            cell.imgCategory.image = UIImage(named: "followed")
            cell.lblUserName.text = NSLocalizedString("notification_start_following_key", comment: "")//notification.from[0]
            cell.lblContent.text = String(format: NSLocalizedString("notification_start_following_body", comment: ""), notification.from[0])
        }
        
        cell.lblDate.text = getTime(timestamp: notification.createdAt)
//
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == qNotifications.count - 1 {
            getNotifications(page: nextPage, limit: 20)
        }
    }
}

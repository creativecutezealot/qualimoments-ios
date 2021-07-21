//
//  MessageViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/5/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var messages = [QMMessage]()
    var nextPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //getMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMessages()
    }
    
    @objc func getMessages(page: Int = 0, limit: Int = 20) {
//        if page == 0 {
//            KVNProgress.show()
//        }
        APIManager.sharedInstance.getMessages(page: page, limit: limit, completion: {
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
                }
                
                if object != nil {
                    if page == 0 {
                        self.messages = []
                    }
                    
                    let msgs = object as! [Any]
                    for m in msgs {
                        let msg = QMMessage.init(dict: m as! [String: Any])
                        self.messages.append(msg)
                    }
                    if msgs.count > 0 {
                        self.tableView.reloadData()
                        self.nextPage = page + 1
                    }
                }
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewMsgViewController") as! NewMsgViewController
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        let msg = messages[indexPath.row]
        
        cell.lblName.text = msg.title
        if msg.picture.count > 0 {
            cell.imgUser.kf.setImage(with: URL(string: msg.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        }
        else {
            cell.imgUser.image = UIImage(named: "unknown_user")
        }
        
        if !msg.unread {
            cell.imgMsg.image = UIImage(named: "read-msg")
        }
        else {
            cell.imgMsg.image = UIImage(named: "unread-msg")
        }
        
        cell.lblDate.text = CommonManager.sharedInstance.getDate(timestamp: Int64(msg.updatedAt))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msg = messages[indexPath.item]
//        if !msg.unread {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.curChat = msg
            self.present(vc, animated: true, completion: nil)
            
//        } else {
//            APIManager.sharedInstance.readMessage(id: msg.id, completion: {
//                error, object in
//                if error == nil {
//
//                    let obj = object as? NSDictionary
//                    if obj != nil {
//                        let err = obj!["error"] as? NSDictionary
//                        if err != nil {
//                            let status = err!["status"] as! Int
//                            if status == 401 {
//                                KVNProgress.dismiss()
//                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
//                            }
//                            else {
//                                let detail = err!["detail"] as! String
//                                KVNProgress.showError(withStatus: detail)
//                            }
//
//                            return
//                        }
//
//
//                    }
//
//
//                    KVNProgress.dismiss()
//                } else {
//                    KVNProgress.showError(withStatus: error!.localizedDescription)
//                }
//            })
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == messages.count - 1 && messages.count >= 20{
            getMessages(page: nextPage, limit: 20)
        }
    }
}

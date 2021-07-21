//
//  ChatViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 2019/3/8.
//  Copyright © 2019 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class ChatViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMsg: UITextField!
    
    var curChat: QMMessage!
    
    var msgs = [QMChat]()
    var nextPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        getMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(getMessages), name:NSNotification.Name(rawValue: "refresh-message"), object: nil)
    }
    
    func configureView() {
        lblTitle.text = curChat.title
        imgAvatar.kf.setImage(with: URL(string: curChat.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @objc func getMessages() {
        APIManager.sharedInstance.getMessagesChat(id: curChat.id, page: 0, limit: 100, completion: {
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
                    //if page == 0 {
                        self.msgs = []
                    //}
                    
                    let msgs = object as! [Any]
                    for m in msgs {
                        let msg = QMChat(dict: m as! [String: Any])
                        self.msgs.append(msg)
                    }
                    
//                    if msgs.count > 0 {
//                        self.nextPage = page + 1
//                    }
//
                    self.msgs.reverse()
                    
                    self.tableView.reloadData()
                    self.tableView.scrollToBottom()
                }
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSend(_ sender: Any) {
        if txtMsg.text!.count == 0 {
            return
            
        }
        let msg = QMChat()
        msg.id = ""
        msg.text = txtMsg.text!
        msg.incoming = false
        msg.read = true
        msg.sent = false
        msg.createdAt = Int(NSDate().timeIntervalSince1970*1000)
        msgs.append(msg)
        tableView.reloadData()
        self.tableView.scrollToBottom()
        sendMsg(msg: txtMsg.text!)
        txtMsg.text = ""
        
    }
    
    func sendMsg(msg: String) {
        APIManager.sharedInstance.sendMessage(msg: msg, id: curChat.id, completion: {
            error, object in
            self.getMessages()
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
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func makeGooglePhotoUrl(id: String) -> String {
        let googleUrl = "https://maps.googleapis.com/maps/api/place/photo?"
        let key = "AIzaSyDv5gyBsg9D_fia69mLXrYvV0ZIoKMX8qY"
        return "\(googleUrl)maxwidth=600&photoreference=\(id)&key=\(key)"
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = msgs[indexPath.row]
        if msg.incoming {
            if msg.place.id.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingPlaceTableViewCell") as! IncomingPlaceTableViewCell
                if msg.place.photos.count > 0 {
                    var photo = msg.place.photos[0]
                    if photo.content.count == 0 {
                        photo = msg.place.photos.last!
                    }
                    
                    let url = photo.type == "url" ? URL(string: photo.content) : URL(string: makeGooglePhotoUrl(id: photo.content))
                    if url != nil {
                        cell.imgPlace.kf.setImage(with: url!, placeholder: UIImage(named: "no_image_background"), options: [.cacheOriginalImage])
                    } else {
                        cell.imgPlace.image = UIImage(named: "no_image_background")
                    }
                } else {
                    cell.imgPlace.image = UIImage(named: "no_image_background")
                }
                cell.lblTitle.text = msg.place.name
                cell.lblAddress.text = msg.place.address
                cell.lblPhone.text = msg.place.phoneNumber
                cell.lblRate.text = "\(msg.place.rating)/5"
                cell.lblDate.text = CommonManager.sharedInstance.getFullDate(timestamp: Int64(msg.createdAt))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingTextTableViewCell") as! IncomingTextTableViewCell
                cell.lblMsg.text = msg.text
                cell.lblDate.text = CommonManager.sharedInstance.getFullDate(timestamp: Int64(msg.createdAt))
                return cell
            }
        } else {
            if msg.place.id.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingPlaceTableViewCell") as! OutcomingPlaceTableViewCell
                if msg.place.photos.count > 0 {
                    var photo = msg.place.photos[0]
                    if photo.content.count == 0 {
                        photo = msg.place.photos.last!
                    }
                    
                    let url = photo.type == "url" ? URL(string: photo.content) : URL(string: makeGooglePhotoUrl(id: photo.content))
                    if url != nil {
                        cell.imgPlace.kf.setImage(with: url!, placeholder: UIImage(named: "no_image_background"), options: [.cacheOriginalImage])
                    } else {
                        cell.imgPlace.image = UIImage(named: "no_image_background")
                    }
                } else {
                    cell.imgPlace.image = UIImage(named: "no_image_background")
                }
                cell.lblTitle.text = msg.place.name
                cell.lblAddress.text = msg.place.address
                cell.lblPhone.text = msg.place.phoneNumber
                cell.lblRate.text = "\(msg.place.rating)/5"
                cell.lblDate.text = CommonManager.sharedInstance.getFullDate(timestamp: Int64(msg.createdAt))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingTextTableViewCell") as! OutcomingTextTableViewCell
                cell.lblMsg.text = msg.text
                cell.lblDate.text = CommonManager.sharedInstance.getFullDate(timestamp: Int64(msg.createdAt))
                cell.imgSent.image = msg.sent ? UIImage(named: "sent_done") : UIImage(named: "ic_time")
                return cell
            }
        }
        
    }
    
    
}

extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

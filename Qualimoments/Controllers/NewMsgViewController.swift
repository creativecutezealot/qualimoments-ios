//
//  NewMsgViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/5/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class NewMsgViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var qmFriends: [QMPeople] = []
    var nextPage = 0
    var msgIndex = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
        
    }
    
    func configureView() {
        lblTitle.text = NSLocalizedString("newMessage", comment: "")
        
    }
    
    func getFriends(page: Int = 0, limit: Int = 20) {
        if page == 0 {
            KVNProgress.show()
        }
        APIManager.sharedInstance.getFriends(page: page, limit: limit, completion: {
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
                        self.qmFriends = []
                    }
                    
                    let friends = result["users"] as! [Any]
                    for people in friends {
                        let friend = QMPeople.init(dict: people as! [String: Any])
                        self.qmFriends.append(friend)
                    }
                    
                    if friends.count > 0 {
                        self.collectionView.reloadData()
                        self.nextPage += 1
                    }
                    
                }
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnWriteMsgTapped(sender: UIButton) {
        let index = sender.tag - msgIndex
        let people = qmFriends[index]
    }
}

extension NewMsgViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == qmFriends.count - 1 {
            getFriends(page: nextPage, limit: 20)
        }
    }
}

extension NewMsgViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return qmFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedPeopleCollectionViewCell", for: indexPath) as! SelectedPeopleCollectionViewCell
        let people = qmFriends[indexPath.item]
        cell.imgAvatar.kf.setImage(with: URL(string: people.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        cell.lblName.text = people.name
        cell.btnMsg.layer.borderColor = UIColor.darkGray.cgColor
        
        cell.btnSepView.isHidden = indexPath.item % 2 != 0
        
        if people.type == "newbie" {
            cell.lblUserType.text = " \(NSLocalizedString("newbie", comment: "")) "
            cell.lblUserType.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
        } else {
            cell.lblUserType.text = " \(people.type) "
            cell.lblUserType.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
        }
        
        cell.btnMsg.tag = indexPath.item + msgIndex
        cell.btnMsg.addTarget(self, action: #selector(btnWriteMsgTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// UICollectionViewDelegateFlowLayout
extension NewMsgViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        let width = collectionView.frame.width / 2
        let height = 210
        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        return cellSize
    }
}

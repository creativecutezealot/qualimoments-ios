//
//  NetworkViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/12/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import Kingfisher
import KVNProgress
import FirebaseMessaging

class NetworkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchConatinerView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var connectView: UIView!
    @IBOutlet weak var imgPeople: UIImageView!
    @IBOutlet weak var btnViewConnect: UIButton!
    @IBOutlet weak var lblConnectionCnt: UILabel!
    @IBOutlet weak var lblViewConnections: UILabel!
    
    @IBOutlet weak var peopleKnowView: UIView!
    @IBOutlet weak var btnPeopleKnow: UIButton!
    
    var qmFriends: [QMPeople] = []
    var nextFriendPage = 0
    var qmPossibleUsers: [QMPeople] = []
    var nextPosUserPage = 0
    var qmSearchedUsers: [QMSearchedPeople] = []
    var state = 0
    var connectionCount = 0
    
    var closeIndex = 1000
    var connectIndex = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView ()
        getPossiblePeople()
        getFriends()
    }
    
    func configureView () {
        txtSearch.placeholder = NSLocalizedString("search", comment: "")
        btnPeopleKnow.setTitle(NSLocalizedString("peopleYouMayKnow", comment: ""), for: .normal)
        lblViewConnections.text = NSLocalizedString("viewConnections", comment: "")
        
        searchConatinerView.layer.borderWidth = 1
        searchConatinerView.layer.borderColor = UIColor.gray.cgColor
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        btnPeopleKnow.setTitleColor(UIColor.white, for: .normal)
        peopleKnowView.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
        
        connectView.backgroundColor = UIColor.white
        imgPeople.image = UIImage(named: "network-selected")
        btnViewConnect.setTitleColor(UIColor.darkGray, for: .normal)
        lblConnectionCnt.textColor = UIColor.darkGray
        lblViewConnections.textColor = UIColor.darkGray
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
    func getPossiblePeople(query: String = "", page: Int = 0, limit: Int = 20) {
        APIManager.sharedInstance.getPossiblePeople(query: query, page: page, limit: limit, completion: { error, object in

            if error == nil {
                
                let obj = object as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        let status = err!["status"] as! Int
                        if status == 401 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                        } else {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                        }
                        
                        return
                    }
                    
                    let result = object as! NSDictionary
                    
                    if page == 0 {
                        self.qmPossibleUsers = []
                    }
                    
                    let Users = result["users"] as! [Any]
                    for user in Users {
                        let people = QMPeople.init(dict: user as! [String: Any])
                        people.connected = false
                        self.qmPossibleUsers.append(people)
                    }
                    
                    if Users.count > 0 {
                        self.collectionView.reloadData()
                        self.nextPosUserPage += 1
                    }
                    
                }
                
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func getFriends(query: String = "", page: Int = 0, limit: Int = 20) {
        APIManager.sharedInstance.getFriends(query: query, page: page, limit: limit, completion: { error, object in
            
            if error == nil {
                
                let obj = object as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        let status = err!["status"] as! Int
                        if status == 401 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                        } else {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                        }
                        
                        return
                    }
                    
                    let result = object as! NSDictionary
                    if page == 0 {
                        self.qmFriends = []
                    }
                    
                    let Users = result["users"] as! [Any]
                    for user in Users {
                        let people = QMPeople.init(dict: user as! [String: Any])
                        people.connected = true
                        self.qmFriends.append(people)
                    }
                    
                    self.lblConnectionCnt.text = "\(self.qmFriends.count)"
                    self.connectionCount = self.qmFriends.count
                    
                    if Users.count > 0 {
                        self.collectionView.reloadData()
                        self.nextFriendPage += 1
                    }
                    
                }
                
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let length = textField.text!.count
        if length > 0 {
            btnSearch.setImage(UIImage(named: "search-close"), for: .normal)
            collectionView.isHidden = true
            tableView.isHidden = false
            
            if length >= 3 {
                APIManager.sharedInstance.searchPeopleByUserName(name: textField.text!, completion: {
                    error, object in
                    
                    if error == nil {
                        
                        let obj = object as? NSDictionary
                        if obj != nil {
                            let err = obj!["error"] as? NSDictionary
                            if err != nil {
                                let status = err!["status"] as! Int
                                if status == 401 {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                                } else {
                                    let detail = err!["detail"] as! String
                                    KVNProgress.showError(withStatus: detail)
                                }
                                
                                return
                            }
                            
                            let result = object as! NSDictionary
                            self.qmSearchedUsers = []
                            let Users = result["users"] as! [Any]
                            for user in Users {
                                let people = QMSearchedPeople.init(dict: user as! [String: Any])
                                self.qmSearchedUsers.append(people)
                            }
                            
                            self.tableView.reloadData()
                        }
                        
                        KVNProgress.dismiss()
                    } else {
                        KVNProgress.showError(withStatus: error!.localizedDescription)
                    }
                })
            }
        } else {
            btnSearch.setImage(UIImage(named: "search"), for: .normal)
            collectionView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    @IBAction func onSearchCtrl(_ sender: Any) {
        btnSearch.setImage(UIImage(named: "search"), for: .normal)
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        
        qmSearchedUsers = []
        collectionView.isHidden = false
        tableView.isHidden = true
    }
    
    @IBAction func onPeopleKnow(_ sender: Any) {
        state = 0
        btnPeopleKnow.setTitleColor(UIColor.white, for: .normal)
        peopleKnowView.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
        
        connectView.backgroundColor = UIColor.white
        imgPeople.image = UIImage(named: "network-selected")
        btnViewConnect.setTitleColor(UIColor.darkGray, for: .normal)
        lblConnectionCnt.textColor = UIColor.darkGray
        lblViewConnections.textColor = UIColor.darkGray
        txtSearch.text = ""
        collectionView.isHidden = false
        tableView.isHidden = true
        
        collectionView.reloadData()
        
        btnSearch.setImage(UIImage(named: "search"), for: .normal)
    }
    
    @IBAction func onViewConnect(_ sender: Any) {
        state = 1
        btnPeopleKnow.setTitleColor(UIColor.darkGray, for: .normal)
        peopleKnowView.backgroundColor = UIColor.white
        
        connectView.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
        imgPeople.image = UIImage(named: "people")
        btnViewConnect.setTitleColor(UIColor.white, for: .normal)
        lblConnectionCnt.textColor = UIColor.white
        lblViewConnections.textColor = UIColor.white
        txtSearch.text = ""
        
        collectionView.isHidden = false
        tableView.isHidden = true
        
        collectionView.reloadData()
        
        btnSearch.setImage(UIImage(named: "search"), for: .normal)
    }
    
    @objc func btnCloseTapped(sender: UIButton) {
        let index = sender.tag - closeIndex
        if state == 0 {
            qmPossibleUsers.remove(at: index)
        } else {
            qmFriends.remove(at: index)
        }
        
        collectionView.reloadData()
    }
    
    @objc func btnConnectTapped(sender: UIButton) {
        let index = sender.tag - connectIndex
        var people: QMPeople!
        if state == 0 {
            people = qmPossibleUsers[index]
        } else {
            people = qmFriends[index]
        }
        
        if people.connected {
            KVNProgress.show()
            APIManager.sharedInstance.disconnectPeople(id: people.id, completion: {
                error, object in
                if error == nil {
                    
                    let obj = object as? NSDictionary
                    if obj != nil {
                        let err = obj!["error"] as? NSDictionary
                        if err != nil {
                            let status = err!["status"] as! Int
                            if status == 401 {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                            } else {
                                let detail = err!["detail"] as! String
                                KVNProgress.showError(withStatus: detail)
                            }
                            
                            return
                        }
                        
                        if self.state == 0 {
                            self.qmPossibleUsers[index].connected = true
                            people.connected = false
                            
                            var ii = -1
                            for i in 0..<self.qmFriends.count {
                                if people.id == self.qmFriends[i].id {
                                    ii = i
                                    break
                                }
                            }
                            
                            if ii != -1 {
                                self.qmFriends.remove(at: ii)
                            }
                            
                            self.connectionCount -= 1
                            self.lblConnectionCnt.text = "\(self.connectionCount)"
                        } else {
                            self.qmFriends[index].connected = false
                            self.connectionCount -= 1
                            self.lblConnectionCnt.text = "\(self.connectionCount)"
                        }
                        
                        Messaging.messaging().unsubscribe(fromTopic: people.id)
                        
                        self.collectionView.reloadData()
                    }
                    
                    KVNProgress.dismiss()
                } else {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
            })
        }
        else {
            KVNProgress.show()
            APIManager.sharedInstance.connectPeople(id: people.id, completion: {
                error, object in
                if error == nil {
                    
                    let obj = object as? NSDictionary
                    if obj != nil {
                        let err = obj!["error"] as? NSDictionary
                        if err != nil {
                            let status = err!["status"] as! Int
                            if status == 401 {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                            } else {
                                let detail = err!["detail"] as! String
                                KVNProgress.showError(withStatus: detail)
                            }
                            
                            return
                        }
                        
                        if self.state == 0 {
                            self.qmPossibleUsers[index].connected = true
                            people.connected = true
                            self.qmFriends.append(people)
                            
                            self.connectionCount += 1
                            self.lblConnectionCnt.text = "\(self.connectionCount)"
                        } else {
                            self.qmFriends[index].connected = true
                            self.connectionCount += 1
                            self.lblConnectionCnt.text = "\(self.connectionCount)"
                        }
                        
                        self.collectionView.reloadData()
                        Messaging.messaging().subscribe(toTopic: people.id)
                    }
                    
                    KVNProgress.dismiss()
                } else {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
            })
        }
    }
    
    @objc func btnConnectTableTapped(sender: UIButton) {
        let index = sender.tag - connectIndex
        let people = qmSearchedUsers[index]
        
        if people.connected {
            KVNProgress.show()
            APIManager.sharedInstance.disconnectPeople(id: people.id, completion: {
                error, object in
                if error == nil {
                    
                    let obj = object as? NSDictionary
                    if obj != nil {
                        let err = obj!["error"] as? NSDictionary
                        if err != nil {
                            let status = err!["status"] as! Int
                            if status == 401 {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                            } else {
                                let detail = err!["detail"] as! String
                                KVNProgress.showError(withStatus: detail)
                            }
                            
                            return
                        }
                        
                        var ii = -1
                        for i in 0..<self.qmPossibleUsers.count {
                            if people.id == self.qmPossibleUsers[i].id {
                                ii = i
                            }
                        }
                        
                        if ii != -1 {
                            self.qmPossibleUsers[ii].connected = false
                        }
                        
                        ii = -1
                        for i in 0..<self.qmFriends.count {
                            if people.id == self.qmFriends[i].id {
                                ii = i
                            }
                        }
                        
                        if ii != -1 {
                            self.qmFriends[ii].connected = false
                        }
                        
                        self.connectionCount -= 1
                        self.lblConnectionCnt.text = "\(self.connectionCount)"
                        
                        self.collectionView.reloadData()
                        
                        self.qmSearchedUsers[index].connected = false
                        self.tableView.reloadData()
                        
                        Messaging.messaging().unsubscribe(fromTopic: people.id)
                    }
                    
                    KVNProgress.dismiss()
                } else {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
            })
        } else {
            KVNProgress.show()
            APIManager.sharedInstance.connectPeople(id: people.id, completion: {
                error, object in
                if error == nil {
                    
                    let obj = object as? NSDictionary
                    if obj != nil {
                        let err = obj!["error"] as? NSDictionary
                        if err != nil {
                            let status = err!["status"] as! Int
                            if status == 401 {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                            } else {
                                let detail = err!["detail"] as! String
                                KVNProgress.showError(withStatus: detail)
                            }
                            
                            return
                        }
                        
                        var ii = -1
                        for i in 0..<self.qmPossibleUsers.count {
                            if people.id == self.qmPossibleUsers[i].id {
                                ii = i
                            }
                        }
                        
                        if ii != -1 {
                            self.qmPossibleUsers[ii].connected = true
                        }
                        
                        
                        ii = -1
                        for i in 0..<self.qmFriends.count {
                            if people.id == self.qmFriends[i].id {
                                ii = i
                            }
                        }
                        
                        if ii != -1 {
                            self.qmFriends[ii].connected = true
                        }
                        
                        self.connectionCount += 1
                        self.lblConnectionCnt.text = "\(self.connectionCount)"
                        
                        self.collectionView.reloadData()
                        
                        self.qmSearchedUsers[index].connected = true
                        self.tableView.reloadData()
                        
                        Messaging.messaging().subscribe(toTopic: people.id)
                    }
                    
                    KVNProgress.dismiss()
                } else {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qmSearchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleConnectTableViewCell") as! PeopleConnectTableViewCell
        
        let people = self.qmSearchedUsers[indexPath.item]
        if people.picture.count > 0 {
            cell.imgAvatar.kf.setImage(with: URL(string: people.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        } else {
            cell.imgAvatar.image = UIImage(named: "unknown_user")
        }

        cell.lblName.text = people.name
        if !people.connected {
            cell.btnConnect.layer.borderWidth = 1
            cell.btnConnect.layer.borderColor = UIColor.gray.cgColor
            cell.btnConnect.setTitle(NSLocalizedString("connect", comment: ""), for: .normal)
            cell.btnConnect.backgroundColor = UIColor.white
            cell.btnConnect.setTitleColor(UIColor.darkGray, for: .normal)
        } else {
            cell.btnConnect.layer.borderWidth = 1
            cell.btnConnect.layer.borderColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0).cgColor
            cell.btnConnect.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
            cell.btnConnect.setTitle(NSLocalizedString("disconnect", comment: ""), for: .normal)
            cell.btnConnect.setTitleColor(UIColor.white, for: .normal)
        }
        
        cell.btnConnect.tag = indexPath.item + connectIndex
        cell.btnConnect.addTarget(self, action: #selector(btnConnectTableTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension NetworkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if state == 0 {
            if indexPath.item == qmPossibleUsers.count - 1 {
                getPossiblePeople(query: "", page: nextPosUserPage, limit: 20)
            }
        } else {
            if indexPath.item == qmFriends.count - 1 {
                getFriends(query: "", page: nextFriendPage, limit: 20)
            }
        }
    }
}

extension NetworkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state == 0 ? qmPossibleUsers.count : qmFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeopleCollectionViewCell", for: indexPath) as! PeopleCollectionViewCell
        
        if indexPath.item % 2 == 1 {
            cell.leftLine.isHidden = true
        } else {
            cell.leftLine.isHidden = false
        }
        
        let people = state == 0 ? qmPossibleUsers[indexPath.item] : qmFriends[indexPath.item]//qmFriends[indexPath.item]
        if people.picture.count > 0 {
            cell.imgAvatar.kf.setImage(with: URL(string: people.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        } else {
            cell.imgAvatar.image = UIImage(named: "unknown_user")
        }
        
        cell.lblName.text = people.name
        
        if people.type == "newbie" {
            cell.lblFeature.text = " \(NSLocalizedString("newbie", comment: "")) "
            cell.lblFeature.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
        } else {
            cell.lblFeature.text = " \(people.type) "
            cell.lblFeature.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
        }
        
        cell.lblConnectCnt.text = "\(people.mutualFriends) \(NSLocalizedString("mutualConnections", comment: ""))"
        
        if !people.connected {
            cell.btnConnect.layer.borderWidth = 1
            cell.btnConnect.layer.borderColor = UIColor.gray.cgColor
            cell.btnConnect.backgroundColor = UIColor.white
            cell.btnConnect.setTitleColor(UIColor.darkGray, for: .normal)
            cell.btnConnect.setTitle(NSLocalizedString("connect", comment: ""), for: .normal)
        } else {
            cell.btnConnect.layer.borderWidth = 1
            cell.btnConnect.layer.borderColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0).cgColor
            cell.btnConnect.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
            cell.btnConnect.setTitleColor(UIColor.white, for: .normal)
            cell.btnConnect.setTitle(NSLocalizedString("connected", comment: ""), for: .normal)
        }
        
        cell.btnClose.tag = indexPath.item + closeIndex
        cell.btnClose.addTarget(self, action: #selector(btnCloseTapped(sender:)), for: .touchUpInside)
        
        cell.btnConnect.tag = indexPath.item + connectIndex
        cell.btnConnect.addTarget(self, action: #selector(btnConnectTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// UICollectionViewDelegateFlowLayout
extension NetworkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        let width = collectionView.frame.width / 2
        let height = 200
        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        return cellSize
    }
}

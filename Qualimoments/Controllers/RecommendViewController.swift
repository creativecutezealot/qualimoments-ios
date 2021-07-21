//
//  RecommendViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/18/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class RecommendViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchConView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var collectionConView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    var array = [QMPeople]()
    
    var placeId: String!
    var recommendIndex = 10000
    var curPage = 0
    var canMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        getFriends()
    }
    
    func configureView() {
        tableView.isHidden = true
        searchConView.layer.borderColor = UIColor.lightGray.cgColor
        
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let length = textField.text!.count
        if length > 0 {
            tableView.isHidden = false
            collectionConView.isHidden = true
            searchPeople(query: textField.text!)
        } else {
            tableView.isHidden = true
            collectionConView.isHidden = false
            getFriends(page: 0)
        }
    }
    
    func getFriends(query: String = "", page: Int = 0, limit: Int = 20) {
        canMore = false
        APIManager.sharedInstance.getFriends(query: query, page: page, limit: limit, completion: {
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
                    
                    let result = object as? [String: Any]
                    let objs = result!["users"] as? [Any]
                    if page == 0 {
                        self.array = []
                    }
                    
                    if objs != nil {
                        
                        if objs!.count > 0 {
                            self.canMore = true
                            self.curPage = page
                        }
                        
                        for obj in objs! {
                            let friend = QMPeople(dict: obj as! [String: Any])
                            self.array.append(friend)
                        }
                    }
                    
                    self.collectionView.reloadData()
                }
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription, on: self.view)
            }
        })
    }
    
    func searchPeople(query: String) {
        APIManager.sharedInstance.searchPeopleByUserName(name: query, completion: {
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
                    
                    let result = object as? [String: Any]
                    let objs = result!["users"] as? [Any]
                    
                    self.array = []
                    
                    
                    if objs != nil {
                        
                        for obj in objs! {
                            let friend = QMPeople(dict: obj as! [String: Any])
                            self.array.append(friend)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription, on: self.view)
            }
        })
    }
    
    @objc func btnRecommendTapped(sender: UIButton) {
        let index = sender.tag - recommendIndex
        let people = array[index]
       
        if people.isSelected {
            return
        }
        
        APIManager.sharedInstance.recommendPlace(placeId: placeId, friendId: people.id, completion: {
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
                    
                    people.isSelected = true
                    
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                }
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription, on: self.view)
            }
        })
        
    }
}

extension RecommendViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == array.count - 1 && canMore {
            getFriends(query: "", page: curPage + 1)
        }
    }
}

extension RecommendViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCollectionViewCell", for: indexPath) as! RecommendCollectionViewCell
        
        if indexPath.item % 2 == 1 {
            cell.leftLine.isHidden = true
        }else {
            cell.leftLine.isHidden = false
        }
        
        let user = array[indexPath.item]
        let photo = URL(string: user.picture)
        if photo != nil {
            cell.imgAvatar.kf.setImage(with: photo!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        } else {
            cell.imgAvatar.image = UIImage(named: "unknown_user")
        }
        
        cell.lblName.text = user.name
        cell.lblConnectionCnt.text = "\(user.mutualFriends) \(NSLocalizedString("mutualConnections", comment: ""))"
        
        if user.type == "newbie" {
            cell.lblFeature.text = " \(NSLocalizedString("newbie", comment: "")) "
            cell.lblFeature.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
        } else {
            cell.lblFeature.text = " \(user.type) "
            cell.lblFeature.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
        }
        
        if !user.isSelected {
            cell.btnRecommend.layer.borderWidth = 1
            cell.btnRecommend.layer.borderColor = UIColor.gray.cgColor
            cell.btnRecommend.backgroundColor = UIColor.white
            cell.btnRecommend.setTitleColor(UIColor.darkGray, for: .normal)
            cell.btnRecommend.setTitle("Recommend", for: .normal)
        } else {
            cell.btnRecommend.layer.borderWidth = 1
            cell.btnRecommend.layer.borderColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0).cgColor
            cell.btnRecommend.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
            cell.btnRecommend.setTitleColor(UIColor.white, for: .normal)
            cell.btnRecommend.setTitle("Recommended", for: .normal)
        }
        
        cell.btnRecommend.tag = indexPath.item + recommendIndex
        cell.btnRecommend.addTarget(self, action: #selector(btnRecommendTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
}

// UICollectionViewDelegateFlowLayout
extension RecommendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        
        let width = collectionView.frame.width / 2
        let height = 200
        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        return cellSize
    }
}

extension RecommendViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
}

extension RecommendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCell") as! RecommendTableViewCell
        
        let user = array[indexPath.item]
        let photo = URL(string: user.picture)
        if photo != nil {
            cell.imgAvartar.kf.setImage(with: photo!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        } else {
            cell.imgAvartar.image = UIImage(named: "unknown_user")
        }
        
        cell.lblName.text = user.name
        
        if !user.isSelected {
            cell.btnRecommend.layer.borderWidth = 1
            cell.btnRecommend.layer.borderColor = UIColor.gray.cgColor
            cell.btnRecommend.backgroundColor = UIColor.white
            cell.btnRecommend.setTitleColor(UIColor.darkGray, for: .normal)
            cell.btnRecommend.setTitle("Recommend", for: .normal)
        } else {
            cell.btnRecommend.layer.borderWidth = 1
            cell.btnRecommend.layer.borderColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0).cgColor
            cell.btnRecommend.backgroundColor = UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0)
            cell.btnRecommend.setTitleColor(UIColor.white, for: .normal)
            cell.btnRecommend.setTitle("Recommended", for: .normal)
        }
        
        cell.btnRecommend.tag = indexPath.item + recommendIndex
        cell.btnRecommend.addTarget(self, action: #selector(btnRecommendTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
}

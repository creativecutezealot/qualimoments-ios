//
//  NewsViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/12/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class NewsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arryNewsFeeds: [QMNewsFeed] = []
    var nextPage = 0
    let shareIndex = 10000
    let likeIndex = 20000
    let phoneIndex = 30000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewsFeeds()
    }
    
    func getNewsFeeds(page: Int = 0, limit: Int = 20) {
        if page == 0 {
            KVNProgress.show()
        }
        APIManager.sharedInstance.getNewsFeeds(page: page, limit:limit, completion: {
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
                        } else {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                        }
                        
                        return
                    }                  
                }               
                
                let newsFeeds = object as? [Any]
                if newsFeeds != nil {
                    
                    if page == 0 {
                        self.arryNewsFeeds = []
                    }
                    
                    for news in newsFeeds! {
                        let n = QMNewsFeed.init(dict: news as! [String: Any])
                        self.arryNewsFeeds.append(n)
                    }
                    
                    if newsFeeds!.count > 0 {
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
    
    @objc func btnShareTapped(sender: UIButton) {
        let index = sender.tag - shareIndex
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report Abuse", style: .default , handler:{ (UIAlertAction)in
            self.reportAbuse(index: index)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            let v = sender as UIView
            popoverPresentationController.sourceView = v
            popoverPresentationController.sourceRect = v.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func btnMoreTapped(sender: UIButton) {
        let index = sender.tag - shareIndex
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("recommend", comment: ""), style: .default , handler:{ (UIAlertAction)in
            self.onRecommend(index: index)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("share", comment: ""), style: .default , handler:{ (UIAlertAction)in
            self.onShare(index: index)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            let v = sender as UIView
            popoverPresentationController.sourceView = v
            popoverPresentationController.sourceRect = v.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func reportAbuse(index: Int) {
        let news = arryNewsFeeds[index]
        let  vc = storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.post = news.post
        present(vc, animated: true, completion: nil)
    }
    
    func onShare(index: Int) {
        let place = arryNewsFeeds[index].review.place.id
        CommonManager.sharedInstance.sharePlace(id: place, vc: self, state: {
            result in
            
        })
        
    }
    
    func onRecommend(index: Int) {
        let place = arryNewsFeeds[index].review.place.id
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.placeId = place
        present(vc, animated: true, completion: nil)
    }
    
    @objc func btnLikeTapped(sender: UIButton) {
        let index = sender.tag - likeIndex
        let news = arryNewsFeeds[index]
        let id = news.post.id
        if news.post.liked || (news.post.owner.id == GlobalData.curUser.id) {
            return
        }
        
        APIManager.sharedInstance.likePost(postId: id, completion: {
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
                        } else {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                        }
                        
                        return
                    }
                    
                    self.arryNewsFeeds[index].post.liked = true
                    self.arryNewsFeeds[index].post.likesCount += 1
                    self.collectionView.reloadData()
                }
                
                
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    @objc func btnLikePlaceTapped(sender: UIButton) {
        let index = sender.tag - likeIndex
        let news = arryNewsFeeds[index]
        let id = news.review.id
        if news.review.liked || (news.review.reviewer.id == GlobalData.curUser.id) {
            return
        }
        
        APIManager.sharedInstance.likeReview(reviewId: id, completion: {
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
                        } else {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                        }
                        
                        return
                    }
                    
                    self.arryNewsFeeds[index].review.liked = true
                    self.arryNewsFeeds[index].review.reviewLikes += 1
                    self.collectionView.reloadData()
                }
                
                
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    @objc func btnPhoneTapped(sender: UIButton) {
        let index = sender.tag - phoneIndex
        let phone = arryNewsFeeds[index].review.place.phoneNumber
        if let url = URL(string: "tel://\(phone)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    func makeGooglePhotoUrl(url: String) -> String {
        let googleUrl = "https://maps.googleapis.com/maps/api/place/photo?"
        let key = "AIzaSyDv5gyBsg9D_fia69mLXrYvV0ZIoKMX8qY"
        return "\(googleUrl)maxwidth=600&photoreference=\(url)&key=\(key)"
    }
}

extension NewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arryNewsFeeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let news = arryNewsFeeds[indexPath.item]
        if news.type == "post" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsItemCollectionViewCell", for: indexPath) as! NewsItemCollectionViewCell
            
            let ownerPicture = URL(string: news.post.owner.picture)
            if ownerPicture != nil {
                cell.imgAvatar.kf.setImage(with: ownerPicture!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
            } else {
                cell.imgAvatar.image = UIImage(named: "unknown_user")
            }
            
            cell.userName.text = news.post.owner.name
            
            let postPicture = URL(string: news.post.picture)
            if postPicture != nil {
                cell.imgMain.kf.setImage(with: postPicture!)
            } else {
                cell.imgMain.image = nil
            }
            
            //cell.lblFeature.isHidden = true
            if news.post.owner.type == "newbie" {
                cell.lblFeature.text = " \(NSLocalizedString("newbie", comment: "")) "
                cell.lblFeature.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
            } else {
                cell.lblFeature.text = " \(news.post.owner.type) "
                cell.lblFeature.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
            }
            
            cell.imgChallenge.isHidden = !news.post.mark
            cell.lblDesc.text = news.post.desc
            var tags = ""
            for t in news.post.tags {
                let tag = t as! [String: String]
                let strTag = tag["tag"]
                if strTag != nil {
                    tags += "#\(strTag!) "
                }
            }
            cell.lblTags.text = tags
            cell.lblLikeCnt.text = "\(news.post.likesCount)"
            
            cell.btnShare.tag = indexPath.item + shareIndex
            cell.btnShare.addTarget(self, action: #selector(btnShareTapped(sender:)), for: .touchUpInside)
            
            cell.btnLike.tag = indexPath.item + likeIndex
            cell.btnLike.addTarget(self, action: #selector(btnLikeTapped(sender:)), for: .touchUpInside)
    
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
            let ownerPicture = URL(string: news.review.reviewer.picture)
            if ownerPicture != nil {
                cell.imgAvartar.kf.setImage(with: ownerPicture!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
            } else {
                cell.imgAvartar.image = UIImage(named: "unknown_user")
            }
            
            cell.lblUserName.text = news.review.reviewer.name
            cell.lblReviewerName.text = news.review.reviewer.name + " rated"
            cell.lblRate.text = "\(news.review.reviewerRating)/5"
            
            if news.review.reviewer.type == "newbie" {
                cell.lblUserType.text = " \(NSLocalizedString("newbie", comment: "")) "
                cell.lblUserType.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
            } else {
                cell.lblUserType.text = " \(news.review.reviewer.type) "
                cell.lblUserType.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
            }
            
            cell.lblReviewDesc.text = news.review.review
            
            let placePhoto = news.review.place.photo.type != "google" ? URL(string: news.review.place.photo.content) : URL(string: makeGooglePhotoUrl(url: news.review.place.photo.content))
            if news.review.review == "Bad food" {
                print(news.review.place.photo.content)
            }
            if placePhoto != nil {
                cell.imgReview.kf.setImage(with: placePhoto!, placeholder: nil, options: [.cacheOriginalImage])
            } else {
                cell.imgReview.image = nil
            }
            
            cell.lblName.text = news.review.place.name
            cell.lblAddress.text = news.review.place.address
            cell.lblPhone.text = news.review.place.phoneNumber
            cell.phoneConView.isHidden = news.review.place.phoneNumber.count == 0
            cell.lblReviewRate.text = "\(news.review.place.rating)/5"

            cell.lblLikeCnt.text = "\(news.review.reviewLikes)"
            
            cell.btnMore.tag = indexPath.item + shareIndex
            cell.btnMore.addTarget(self, action: #selector(btnMoreTapped(sender:)), for: .touchUpInside)
            
            cell.btnLike.tag = indexPath.item + likeIndex
            cell.btnLike.addTarget(self, action: #selector(btnLikePlaceTapped(sender:)), for: .touchUpInside)
            
            cell.btnPhone.tag = indexPath.item + phoneIndex
            cell.btnPhone.addTarget(self, action: #selector(btnPhoneTapped(sender:)), for: .touchUpInside)
            
            return cell
        }
    }
}

extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == arryNewsFeeds.count - 1 {
            getNewsFeeds(page: nextPage, limit: 20)
        }
    }
}

// UICollectionViewDelegateFlowLayout
extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        
        let width = collectionView.frame.width
        let news = arryNewsFeeds[indexPath.item]
        var height = width * 1.2
        if news.type == "post" {
            height = width * 1.2
        } else {
            height = width
        }
        
        
        //157
        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        return cellSize
    }
}




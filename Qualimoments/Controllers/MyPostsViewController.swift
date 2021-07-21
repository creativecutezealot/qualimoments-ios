//
//  MyPostsViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/10/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class MyPostsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myPosts: [QMPost] = []
    var nextPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMyPosts()
    }
    
    func configureView() {
        lblTitle.text = NSLocalizedString("myPosts", comment: "")
    }
    
    func getMyPosts(page: Int = 0, limit: Int = 20) {
        
        if page == 0 {
            KVNProgress.show()
        }
        
        APIManager.sharedInstance.getMyPosts(page: page, limit: limit, completion: { error, object in

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
                
                
                if page == 0 {
                    self.myPosts = []
                }
                
                let posts = object as! [Any]
                
                for p in posts {
                    let post = QMPost.init(dict: p as! [String: Any])
                    self.myPosts.append(post)
                }
                
                if posts.count > 0 {
                    self.nextPage += 1
                    self.collectionView.reloadData()
                }

                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }


    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddNewPost(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyPostsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsItemCollectionViewCell", for: indexPath) as! NewsItemCollectionViewCell
        
        let post = myPosts[indexPath.item]

        cell.imgMain.kf.setImage(with: URL(string: post.picture)!)

        cell.lblDesc.text = post.desc
        cell.lblLikeCnt.text = "\(post.likesCount)"
        cell.lblRecommendCnt.text = "\(post.commentsCount)"

//        cell.imgMark.isHidden = !post.mark

        var tags = ""
        for t in post.tags {
            let tag = t as! [String: String]
            let strTag = tag["tag"]
            tags += "#\(strTag!) "
        }

        cell.lblTags.text = tags
        cell.imgChallenge.isHidden = !post.mark
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        return cell
    }
}

// UICollectionViewDelegateFlowLayout
extension MyPostsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        
        let width = collectionView.frame.width
        let height = width
        
        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        return cellSize
    }
}

// UICollectionViewDelegate
extension MyPostsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == myPosts.count - 1 {
            getMyPosts(page: nextPage, limit: 20)
        }
    }
}




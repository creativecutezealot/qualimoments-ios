//
//  Top10DetailViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/15/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class Top10DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var galaryCollectionView: UICollectionView!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    
    @IBOutlet weak var lblReviewPlace: UILabel!
    @IBOutlet weak var btnReviewPlace: UIButton!
    @IBOutlet weak var txtDesc: UITextView!
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var reviewTableView: UITableView!
    
    @IBOutlet weak var bottomContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pageCtrl: UIPageControl!
    
    var reviews = [QMMyReview]()
    var nextPage = 0
    var state = 0
    
    var place: QMPlace!
    var placeDetail = QMPlaceDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        getPlaceDetail()
        getReviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureView() {
        infoView.isHidden = true
        reviewView.isHidden = true
        pageCtrl.numberOfPages = place.photos.count
        pageCtrl.currentPage = 0
        
    }
    
    func reloadScreen() {
        infoView.isHidden = state != 0
        reviewView.isHidden = state == 0
        pageCtrl.numberOfPages = place.photos.count
        pageCtrl.currentPage = 0
        
        lblTitle.text = placeDetail.place.name
        lblCity.text = placeDetail.city.name
        lblRate.text = "\(placeDetail.place.rating)/5"
        txtDesc.text = placeDetail.place.desc
        
        galaryCollectionView.reloadData()
        reviewTableView.reloadData()
        
        if placeDetail.myReview.id.count > 0 {
            btnReviewPlace.backgroundColor = UIColor(red: 253/255, green: 204/255, blue: 0/255, alpha: 0.3)
        }
        
        adjustBottomHeight()
    }
    
    func getPlaceDetail() {
        KVNProgress.show()
        APIManager.sharedInstance.getPlaceDetail(id: place.id, completion: {
            error, object in
            if error == nil {
                let obj = object as? [String: Any]
                if obj != nil {
                    let err = obj!["error"] as? [String: Any]
                    if err != nil {
                        
                        let detail = err!["detail"] as! String
                        KVNProgress.showError(withStatus: detail)
                        
                        return
                    }
                    
                    self.placeDetail = QMPlaceDetail(dict: obj!)
                    self.reloadScreen()
                }
                
                KVNProgress.dismiss()
                
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func getReviews(page: Int = 0, limit: Int = 20) {
        APIManager.sharedInstance.getPlaceReviews(id: place.id, page: page, limit: limit, completion: {
            error, object in
            if error == nil {
                let obj = object as? [String: Any]
                if obj != nil {
                    let err = obj!["error"] as? [String: Any]
                    if err != nil {
                        
                        let detail = err!["detail"] as! String
                        KVNProgress.showError(withStatus: detail)
                        
                        return
                    }
                    
                    
                }
                
                if page == 0 {
                    self.reviews = []
                }
                
                let rs = object as? [Any]
                if rs != nil {
                    for r in rs! {
                        let review = QMMyReview(dict: r as! [String: Any])
                        self.reviews.append(review)
                    }
                    
                    if rs!.count > 0 {
                        
                        self.nextPage += 1
                    }
                }
                self.reloadScreen()
                KVNProgress.dismiss()
                
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func adjustBottomHeight() {
        if state == 0 {
            if txtDesc.contentSize.height > 354 {
                bottomContentHeight.constant = txtDesc.contentSize.height + 94
            } else {
                bottomContentHeight.constant = 354
            }
        } else {
            if reviewTableView.contentSize.height > 354 {
                bottomContentHeight.constant = reviewTableView.contentSize.height + 94
            } else {
                bottomContentHeight.constant = 354
            }
        }
    }

    @IBAction func onInfo(_ sender: Any) {
        btnInfo.setTitleColor(UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0), for: .normal)
        btnReview.setTitleColor(UIColor.darkGray, for: .normal)
        
        infoView.isHidden = false
        reviewView.isHidden = true
        state = 0
        adjustBottomHeight()
    }
    
    @IBAction func onReview(_ sender: Any) {
        btnReview.setTitleColor(UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0), for: .normal)
        btnInfo.setTitleColor(UIColor.darkGray, for: .normal)
        
        infoView.isHidden = true
        reviewView.isHidden = false
        state = 2
        
        adjustBottomHeight()
    }
    
    func calcReview(review: QMMyReview) -> Double {
        var cnt = 0
        cnt = review.value1 ? cnt + 1 : cnt
        cnt = review.value2 ? cnt + 1 : cnt
        cnt = review.value3 ? cnt + 1 : cnt
        cnt = review.value4 ? cnt + 1 : cnt
        cnt = review.value5 ? cnt + 1 : cnt
        cnt = review.value6 ? cnt + 1 : cnt
        var rate = 0.0
        switch cnt {
        case 0:
            rate = 0.0
            break
        case 1:
            rate = 0.8
            break
        case 2:
            rate = 1.7
            break
        case 3:
            rate = 2.5
            break
        case 4:
            rate = 3.3
            break
        case 5:
            rate = 4.1
            break
        case 6:
            rate = 5.0
            break
        default: break
            
        }
        return rate
    }
    
    @IBAction func onSetReview(_ sender: Any) {
        if placeDetail.myReview.id.count > 0 {
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.placeId = place.id
        vc.parentVC = self
        present(vc, animated: true, completion: nil)
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-review"), object: nil)
    }
    
    @IBAction func onRecommend(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RecommendViewController") as! RecommendViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.placeId = place.id
        present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
        let review = reviews[indexPath.row]
        cell.lblUserName.text = review.profile.name
        if review.profile.type == "newbie" {
            cell.lblFeature.text = " \(NSLocalizedString("newbie", comment: "")) "
            cell.lblFeature.backgroundColor = UIColor(red: 240/255, green: 213/255, blue: 103/255, alpha: 1)
        } else {
            cell.lblFeature.text = " \(review.profile.type) "
            cell.lblFeature.backgroundColor = UIColor(red: 97/255, green: 216/255, blue: 184/255, alpha: 1)
        }
        
        cell.lblDate.text = CommonManager.sharedInstance.getDate(timestamp: Int64(review.createdAt))
        cell.lblUserRated.text = review.profile.name + " rated"
        cell.lblDesc.text = review.review
        let ownerPicture = URL(string: review.profile.picture)
        if ownerPicture != nil {
            cell.imgAvatar.kf.setImage(with: ownerPicture!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        } else {
            cell.imgAvatar.image = UIImage(named: "unknown_user")
        }
        
        cell.lblScore.text = "\(calcReview(review: review))/5"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func makeGooglePhotoUrl(id: String) -> String {
        let googleUrl = "https://maps.googleapis.com/maps/api/place/photo?"
        let key = "AIzaSyDv5gyBsg9D_fia69mLXrYvV0ZIoKMX8qY"
        return "\(googleUrl)maxwidth=600&photoreference=\(id)&key=\(key)"
    }
}

extension Top10DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        for c in collectionView.visibleCells {
            let index = collectionView.indexPath(for: c)
            pageCtrl.currentPage = index!.item
            break
        }
        
    }
}

extension Top10DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = place.photos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        
       
        let url = photo.type == "url" ? URL(string: photo.content) : URL(string: makeGooglePhotoUrl(id: photo.content))
        if url != nil {
            cell.imageView.kf.setImage(with: url!, placeholder: UIImage(named: "no_image_background"), options: [.cacheOriginalImage])
        } else {
            cell.imageView.image = UIImage(named: "no_image_background")
        }
        
        
        return cell
    }
}

// UICollectionViewDelegateFlowLayout
extension Top10DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize(width: CGFloat(0), height: 0)
        
        let width = collectionView.frame.width
        let height = collectionView.frame.height

        cellSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        
        return cellSize
    }
}

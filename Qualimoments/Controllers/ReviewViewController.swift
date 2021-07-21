//
//  ReviewViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/15/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class ReviewViewController: UIViewController {

    //Food
    @IBOutlet weak var btnFoodLike: UIButton!
    @IBOutlet weak var btnFoodUnlike: UIButton!
    
    //Service
    @IBOutlet weak var btnServiceLike: UIButton!
    @IBOutlet weak var btnServiceUnlike: UIButton!
    
    //Facilities
    @IBOutlet weak var btnFacLike: UIButton!
    @IBOutlet weak var btnFacUnlike: UIButton!
    
    //Cleanliness
    @IBOutlet weak var btnCleanLike: UIButton!
    @IBOutlet weak var btnCleanUnlike: UIButton!
    
    //Atmosphere
    @IBOutlet weak var btnAtmosLike: UIButton!
    @IBOutlet weak var btnAtmosUnlike: UIButton!
    
    //Value of money
    @IBOutlet weak var btnMoneyLike: UIButton!
    @IBOutlet weak var btnMoneyUnlike: UIButton!
    
    @IBOutlet weak var txtReview: UITextView!
    
    @IBOutlet weak var lblRating: UILabel!
    var ratingVal = [false, false, false, false, false, false]
    var rating: Double = 0.0
    var placeId = ""
    
    var parentVC: Top10DetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        txtReview.layer.borderColor = UIColor.lightGray.cgColor
        lblRating.text = "0/5"
    }

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSend(_ sender: Any) {
        let msg = txtReview.text!
        if msg.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please write message")
            return
        }
        
        let body: [String : Any] =  [
            "review": msg,
            "rating": rating,
            "value1": ratingVal[0],
            "value2": ratingVal[1],
            "value3": ratingVal[2],
            "value4": ratingVal[3],
            "value5": ratingVal[4],
            "value6": ratingVal[5]
            ]
        
        APIManager.sharedInstance.sendReview(placeId: placeId, body: body, completion: {
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
                
                KVNProgress.dismiss()
                
                self.dismiss(animated: true, completion: {
                    self.parentVC.getPlaceDetail()
                    self.parentVC.getReviews()
                })
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
        
    }
    
    //Food quality
    @IBAction func onFoodLike(_ sender: Any) {
        btnFoodLike.setImage(UIImage(named: "like-blue"), for: .normal)
        btnFoodUnlike.setImage(UIImage(named: "unlike-grey"), for: .normal)
        ratingVal[0] = true
        calcRating()
    }
    
    @IBAction func onFoodUnlike(_ sender: Any) {
        btnFoodLike.setImage(UIImage(named: "like-grey"), for: .normal)
        btnFoodUnlike.setImage(UIImage(named: "unlike-red"), for: .normal)
        ratingVal[0] = false
        calcRating()
    }
    
    //Service
    @IBAction func onServiceLike(_ sender: Any) {
        btnServiceLike.setImage(UIImage(named: "like-blue"), for: .normal)
        btnServiceUnlike.setImage(UIImage(named: "unlike-grey"), for: .normal)
        ratingVal[1] = true
        calcRating()
    }
    
    @IBAction func onServiceUnlike(_ sender: Any) {
        btnServiceLike.setImage(UIImage(named: "like-grey"), for: .normal)
        btnServiceUnlike.setImage(UIImage(named: "unlike-red"), for: .normal)
        ratingVal[1] = false
        calcRating()
    }
    
    //Facilities
    @IBAction func onFacLike(_ sender: Any) {
        btnFacLike.setImage(UIImage(named: "like-blue"), for: .normal)
        btnFacUnlike.setImage(UIImage(named: "unlike-grey"), for: .normal)
        ratingVal[2] = true
        calcRating()
    }
    
    @IBAction func onFacUnlike(_ sender: Any) {
        btnFacLike.setImage(UIImage(named: "like-grey"), for: .normal)
        btnFacUnlike.setImage(UIImage(named: "unlike-red"), for: .normal)
        ratingVal[2] = false
        calcRating()
    }
    
    //Cleanliness
    @IBAction func onCleanLike(_ sender: Any) {
        btnCleanLike.setImage(UIImage(named: "like-blue"), for: .normal)
        btnCleanUnlike.setImage(UIImage(named: "unlike-grey"), for: .normal)
        ratingVal[3] = true
        calcRating()
    }
    
    @IBAction func onCleanUnlike(_ sender: Any) {
        btnCleanLike.setImage(UIImage(named: "like-grey"), for: .normal)
        btnCleanUnlike.setImage(UIImage(named: "unlike-red"), for: .normal)
        ratingVal[3] = false
        calcRating()
    }
    
    //Atmosphere
    @IBAction func onAtmosLike(_ sender: Any) {
        btnAtmosLike.setImage(UIImage(named: "like-blue"), for: .normal)
        btnAtmosUnlike.setImage(UIImage(named: "unlike-grey"), for: .normal)
        ratingVal[4] = true
        calcRating()
    }
    
    @IBAction func onAtmosUnlike(_ sender: Any) {
        btnAtmosLike.setImage(UIImage(named: "like-grey"), for: .normal)
        btnAtmosUnlike.setImage(UIImage(named: "unlike-red"), for: .normal)
        ratingVal[4] = false
        calcRating()
    }
    
    //Value of money
    @IBAction func onMoneyLike(_ sender: Any) {
        btnMoneyLike.setImage(UIImage(named: "like-blue"), for: .normal)
        btnMoneyUnlike.setImage(UIImage(named: "unlike-grey"), for: .normal)
        ratingVal[5] = true
        calcRating()
    }
    
    @IBAction func onMoneyUnlike(_ sender: Any) {
        btnMoneyLike.setImage(UIImage(named: "like-grey"), for: .normal)
        btnMoneyUnlike.setImage(UIImage(named: "unlike-red"), for: .normal)
        ratingVal[5] = false
        calcRating()
    }
    
    func calcRating() {
        var cnt = 0
        for rate in ratingVal {
            if rate {
                cnt += 1
            }
        }
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
        
        lblRating.text = "\(rate)/5"
        rating = rate
    }
}

//
//  BottomViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/14/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import ISHPullUp

class PullUpViewController: UIViewController , ISHPullUpSizingDelegate, ISHPullUpStateDelegate {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var topView: UIView!
   
    @IBOutlet weak var lblTop10In: UILabel!
    @IBOutlet weak var lblLocationChoose: UILabel!
    @IBOutlet weak var lblRestaurant: UILabel!
    @IBOutlet weak var lblCafeeShop: UILabel!
    @IBOutlet weak var lblHotels: UILabel!
    @IBOutlet weak var lblCarRental: UILabel!
    @IBOutlet weak var lblTourist: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    var halfWayPoint = CGFloat(0)
    var totalHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        topView.addGestureRecognizer(tapGesture)
        
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCity), name:NSNotification.Name(rawValue: "selected-city"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true;
        lblCity.text = GlobalData.selectedCity.id.count > 0 ? GlobalData.selectedCity.name : "Unknown"
    }
    
    @objc func refreshCity() {
        lblCity.text = GlobalData.selectedCity.id.count > 0 ? GlobalData.selectedCity.name : "Unknown"
    }
    
    func configureView() {
        totalHeight = view.bounds.height - 100
        lblTop10In.text = NSLocalizedString("top10In", comment: "")
        lblLocationChoose.text = NSLocalizedString("chooseOtherCity", comment: "")
        lblRestaurant.text = NSLocalizedString("restaurant", comment: "")
        lblCafeeShop.text = NSLocalizedString("caffeShop", comment: "")
        lblHotels.text = NSLocalizedString("hotels", comment: "")
        lblCarRental.text = NSLocalizedString("carRental", comment: "")
        lblTourist.text = NSLocalizedString("touristAttractions", comment: "")
        lblOther.text = NSLocalizedString("other", comment: "")
    }
    
    @objc func handleTapGesture(gesture: UITapGestureRecognizer) {
        pullUpController.toggleState(animated: true)
    }

    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return 40
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        if height < totalHeight / 4 {
            return 40
        } else if height >= totalHeight / 4 && height <= totalHeight / 4 * 3 {
            return halfWayPoint
        } else {
            return totalHeight
        }
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController contentVC: UIViewController) {
        
    }
    
    @IBAction func onRestaurant(_ sender: Any) {
        
        if GlobalData.selectedCity.id.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select a city")
            return
        }
        
        GlobalData.top10Type = "restaurant"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-top10"), object: nil)
    }
    
    @IBAction func onCafee(_ sender: Any) {
        if GlobalData.selectedCity.id.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select a city")
            return
        }
        GlobalData.top10Type = "cafe"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-top10"), object: nil)
    }
    
    @IBAction func onHotel(_ sender: Any) {
        if GlobalData.selectedCity.id.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select a city")
            return
        }
        GlobalData.top10Type = "hotel"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-top10"), object: nil)
    }
    
    @IBAction func onCarRental(_ sender: Any) {
        if GlobalData.selectedCity.id.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select a city")
            return
        }
        GlobalData.top10Type = "car_rental"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-top10"), object: nil)
    }
    
    @IBAction func onTourist(_ sender: Any) {
        if GlobalData.selectedCity.id.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select a city")
            return
        }
        GlobalData.top10Type = "tourist_attractions"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-top10"), object: nil)
    }
    
    @IBAction func onOther(_ sender: Any) {
        if GlobalData.selectedCity.id.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: "Warning", msg: "Please select a city")
            return
        }
        GlobalData.top10Type = "other"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-top10"), object: nil)
    }
    
    @IBAction func onCity(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-find-city"), object: nil)
    }   
}

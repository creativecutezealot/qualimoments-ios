//
//  UserViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/12/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import GoogleMaps
import KVNProgress
class UserViewController: UIViewController/*, UITableViewDelegate, UITableViewDataSource*/{
    var myPosts: [QMPost] = []
    
    @IBOutlet weak var imagAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblToursCnt: UILabel!
    @IBOutlet weak var lblTours: UILabel!
    @IBOutlet weak var lblPostsCnt: UILabel!
    @IBOutlet weak var lblPosts: UILabel!
    @IBOutlet weak var lblReviewsCnt: UILabel!
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var lblFriendsCnt: UILabel!
    @IBOutlet weak var lblFriends: UILabel!
    @IBOutlet weak var btnMsg: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    var map:GMSMapView!
    
    var curUser: QMUser!
    var cities: [QMCity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()        

        GlobalData.myTours = []
        NotificationCenter.default.addObserver(self, selector: #selector(onBack), name:NSNotification.Name(rawValue: "back"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(getMyProfile), name:NSNotification.Name(rawValue: "reload-profile"), object: nil)
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMyProfile()
    }
    
    func configureView() {
        lblTours.text = NSLocalizedString("tours", comment: "")
        lblReviews.text = NSLocalizedString("reviews", comment: "")
        lblPosts.text = NSLocalizedString("posts", comment: "")
        lblFriends.text = NSLocalizedString("Friends", comment: "")
        
    }
    
    @objc func getMyProfile() {
//        KVNProgress.show()
        APIManager.sharedInstance.getMyProfile(completion: {
            error, result in
            KVNProgress.dismiss()
            if error == nil {
                
                let obj = result as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                        return
                    }
                    
                    let user = QMUser.init(dict: result as! NSDictionary)
                    self.curUser = user
                    GlobalData.curUser = user
                    self.configureUser()
                }
                
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
            }
            
        })
    }

    @objc func onBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onMessage(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "open-messages"), object: nil)
    }    
    
    @IBAction func onEdit(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("editProfile", comment: ""), style: .default , handler:{ (UIAlertAction)in
            
            GlobalData.navCount += 1
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
            self.navigationController?.pushViewController(vc, animated: true)
            GlobalData.childTitle = NSLocalizedString("editProfile", comment: "")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-to-category"), object: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("logout1", comment: ""), style: .default , handler:{ (UIAlertAction)in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            let v = sender as! UIView
            popoverPresentationController.sourceView = v
            popoverPresentationController.sourceRect = v.bounds
        }
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func configureUser() {
        imagAvatar.kf.setImage(with: URL(string: curUser.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        lblName.text = curUser.name
        
        if curUser.city.name.count > 0 && curUser.city.country.name.count > 0 {
            lblLocation.text = curUser.city.name + ", " + curUser.city.country.name
        }
        
        lblDesc.text = curUser.desc
        lblToursCnt.text = "\(curUser.toursCount)"
        lblReviewsCnt.text = "\(curUser.reviewsCount)"
        lblPostsCnt.text = "\(curUser.postsCount)"
        lblFriendsCnt.text = "\(curUser.friendsCount)"
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.383682, longitude: 2.176591, zoom: 4.0)
        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find marker")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        self.mapView.addSubview(map)
        getCities()
    }
    
    func getCities() {
        let myId = GlobalData.curUser.id
        APIManager.sharedInstance.getUserTours(id: myId, completion: {
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
                
                let cs = object as? [Any]
                self.cities = []
                if cs != nil {
                    for c in cs! {
                        let city = QMCity(dict: c as! NSDictionary)
                        self.cities.append(city)
                    }
                    
                    GlobalData.myTours = self.cities
                    self.addMark()
                }
                
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func addMark() {
        var marker: GMSMarker!
        for city in cities {
            marker = GMSMarker(position: CLLocationCoordinate2DMake(city.lat, city.lng))
            marker.title = city.name
            marker.icon = UIImage(named: "mark")
            marker.map = map
        }
    }
    
    @IBAction func onTours(_ sender: Any) {
        GlobalData.navCount += 1
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToursViewController") as! ToursViewController
        self.navigationController?.pushViewController(vc, animated: true)
        GlobalData.childTitle = NSLocalizedString("tours", comment: "")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-to-category"), object: nil)
    }    
    
    @IBAction func onPosts(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-to-myposts"), object: nil)
    }
}

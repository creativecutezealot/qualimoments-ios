//
//  HomeViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/11/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import GoogleMaps
import ISHPullUp
import KVNProgress
class HomeViewController: ISHPullUpViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var lblPressMenu: UILabel!
    
    var map:GMSMapView!
    var cities: [QMCity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        if GlobalData.curUser.id.count > 0 {
            getCities()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(getCities), name:NSNotification.Name(rawValue: "completed-get-user"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onBack), name:NSNotification.Name(rawValue: "back"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(navToResult), name:NSNotification.Name(rawValue: "nav-result"), object: nil)
    }
    
    func configureView() {
        configureMapView()
    }
    
    func configureMapView() {
        lblPressMenu.text = NSLocalizedString("pressOnThisButtonForMenu", comment: "")
        let camera = GMSCameraPosition.camera(withLatitude: 41.383682, longitude: 2.176591, zoom: 4.0)
        map = GMSMapView.map(withFrame: self.mapView.bounds, camera: camera)
        
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.mapView.addSubview(map)
    }
    
    @objc func getCities() {
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
                if cs != nil {
                    for c in cs! {
                        let city = QMCity(dict: c as! NSDictionary)
                        self.cities.append(city)
                    }
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
    
    func setupPullVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "PullUpViewController") as! PullUpViewController
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
    }
    
    @objc func onBack() {        
        navigationController?.popViewController(animated: true)        
    }
    
    @IBAction func onCategory(_ sender: Any) {
        categoryView.isHidden = true
        setupPullVC()
    }
    
    @objc func navToResult() {
        GlobalData.navCount += 1
        let vc = storyboard?.instantiateViewController(withIdentifier: "Top10ResultViewController") as! Top10ResultViewController
        vc.category = GlobalData.selectedCategory
        navigationController?.pushViewController(vc, animated: true)
        GlobalData.childTitle = NSLocalizedString("qualimoments", comment: "")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-to-category"), object: nil)
    }
}

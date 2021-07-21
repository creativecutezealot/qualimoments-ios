//
//  CategoryViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/13/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import ISHPullUp
import GoogleMaps

class CategoryViewController: ISHPullUpViewController {
    
    @IBOutlet weak var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(navToResult), name:NSNotification.Name(rawValue: "nav-result"), object: nil)
    }

    func commonInit() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "PullUpViewController") as! PullUpViewController
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        sizingDelegate = bottomVC
        stateDelegate = bottomVC
    }
    
    func configureView() {
        configureMapView()
    }
    
    func configureMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let map = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        do {
            // Set the map style by passing the URL of the local file.
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
    
    @objc func navToResult() {
        GlobalData.navCount += 1
        let vc = storyboard?.instantiateViewController(withIdentifier: "Top10ResultViewController") as! Top10ResultViewController
        navigationController?.pushViewController(vc, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-to-category"), object: nil)
    }
}

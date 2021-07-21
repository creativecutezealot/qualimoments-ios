//
//  ToursViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/24/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class ToursViewController: UIViewController {
    @IBOutlet weak var lblPlacesVisited: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblToursCount: UILabel!
    
    var tours:[QMCity] = []
    var closeIndex = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tours = GlobalData.myTours
        lblToursCount.text = "\(tours.count)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTours), name:NSNotification.Name(rawValue: "refresh-tours"), object: nil)
        configureView()
    }
    
    func configureView() {
        lblPlacesVisited.text = NSLocalizedString("placesVisited", comment: "")
    }
    
    @objc func refreshTours() {
        for tour in GlobalData.selectedTours {
            tours.append(tour)
        }
        
        GlobalData.myTours = tours
        tableView.reloadData()
        
        var cities: [Any] = []
        for city in tours {
            cities.append(city.getDict())
        }
        
        APIManager.sharedInstance.updateTours(cities: cities, completion: {
            err, res in
            if err == nil {
                let result = res as! NSDictionary
                let error = result["error"] as? NSDictionary
                if error != nil {
                    let detail = error!["detail"] as! String
                    KVNProgress.showError(withStatus: detail, on: self.view)
                } else {
                    self.lblToursCount.text = "\(self.tours.count)"
                    self.tableView.reloadData()
                }
            } else {
                KVNProgress.showError(withStatus: err?.localizedDescription, on: self.view)
            }
        })
    }
    
    @IBAction func onAdd(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-add-tours"), object: nil)
    }
    
    @objc func btnCloseTapped(sender: UIButton) {
        let index = sender.tag - closeIndex
        let tour = tours[index]
        var i = -1
        for ii in 0..<tours.count {
            if tours[ii].id == tour.id {
                i = ii
                break
            }
        }
        
        if i != -1 {
            tours.remove(at: i)
        }
        
        GlobalData.myTours = tours
        var cities: [Any] = []
        for city in tours {
            cities.append(city.getDict())
        }
        
        APIManager.sharedInstance.updateTours(cities: cities, completion: {
            err, res in
            if err == nil {
                let result = res as! NSDictionary
                let error = result["error"] as? NSDictionary
                if error != nil {
                    let detail = error!["detail"] as! String
                    KVNProgress.showError(withStatus: detail, on: self.view)
                } else {
                    self.lblToursCount.text = "\(self.tours.count)"
                    self.tableView.reloadData()
                }
            } else {
                KVNProgress.showError(withStatus: err?.localizedDescription, on: self.view)
            }
        })
    }
}

extension ToursViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToursTableViewCell") as! ToursTableViewCell
        let tour = tours[indexPath.item]
        cell.lblRank.text = "\(indexPath.row + 1)"
        cell.lblName.text = tour.name + ", " + tour.country.name
        //        cell.lblCity.text = city.city
        //        cell.lblCountry.text = city.country
        //
        cell.btnClose.tag = indexPath.item + closeIndex
        cell.btnClose.addTarget(self, action: #selector(btnCloseTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension ToursViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

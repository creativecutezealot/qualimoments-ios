//
//  Top10ResultViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/15/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class Top10ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var category: CategoryItem!
    
    var places = [QMPlace]()
    var nextPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        getPlaces(city: GlobalData.selectedCity.id, category: category.id)
    }
    
    func configureView() {
        
    }
    
    func getPlaces(city: String, category: String, page: Int = 0, limit: Int = 20) {
        APIManager.sharedInstance.getPlaces(city: city, category: category, page: page, limit: limit, completion: {
            error, object in
            
            if error == nil {
                let obj = object as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        
                        let detail = err!["detail"] as! String
                        KVNProgress.showError(withStatus: detail)
                        
                        return
                    }
                }
                
                if page == 0 {
                    self.places = []
                }
                
                let ps = object as? NSArray
                if ps != nil {
                    for p in ps! {
                        let place = QMPlace(dict: p as! [String: Any])
                        self.places.append(place)
                    }
                    
                    if ps!.count > 0 {
                        self.tableView.reloadData()
                        self.nextPage += 1
                    }
                }
                else {
                    self.tableView.reloadData()
                }
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func makeGooglePhotoUrl(id: String) -> String {
        let googleUrl = "https://maps.googleapis.com/maps/api/place/photo?"
        let key = "AIzaSyDv5gyBsg9D_fia69mLXrYvV0ZIoKMX8qY"
        return "\(googleUrl)maxwidth=600&photoreference=\(id)&key=\(key)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top10ResultTableViewCell") as! Top10ResultTableViewCell
        let item = places[indexPath.row]
        
        cell.lblRank.text = "\(indexPath.row + 1)"
        cell.lblTitle.text = item.name
        cell.lblDesc.text = item.desc.components(separatedBy: "Located").first
        cell.lblCity.text = GlobalData.selectedCity.name
        cell.lblScore.text = "\(item.rating)/5"
        cell.imgBk.image = UIImage(named: "quali-item")
        
        if item.photos.count > 0 {
            var photo = item.photos[0]
            if photo.content.count == 0 {
                photo = item.photos.last!
            }
            
            let url = photo.type == "url" ? URL(string: photo.content) : URL(string: makeGooglePhotoUrl(id: photo.content))
            if url != nil {
                cell.imgBk.kf.setImage(with: url!, placeholder: UIImage(named: "no_image_background"), options: [.cacheOriginalImage])
            } else {
                cell.imgBk.image = UIImage(named: "no_image_background")
            }
        } else {
            cell.imgBk.image = UIImage(named: "no_image_background")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        GlobalData.navCount += 1
        
        let place = places[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "Top10DetailViewController") as! Top10DetailViewController
        vc.place = place
        navigationController?.pushViewController(vc, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-to-category"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == places.count - 1 {
            getPlaces(city: GlobalData.selectedCity.id, category: category.id, page: nextPage, limit: 20)
        }
        
    }
    
}

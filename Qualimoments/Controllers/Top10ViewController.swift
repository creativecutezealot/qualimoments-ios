//
//  Top10ViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/14/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class Top10ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var categories:[CategoryItem] = []
    
    var cellHeight = CGFloat(0)
    var nextPage = 0
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getCategoryList(type: type)
    }
    
    func getCategoryList(type: String, page: Int = 0, limit: Int = 20) {
        APIManager.sharedInstance.getCategoryList(type: type, page: page, limit: limit, completion: {
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
                    
                    let result = object as! NSDictionary
                    //print(result)
                    if page == 0 {
                        self.categories = []
                    }

                    let cats = result["categories"] as? [Any]
                    if cats != nil {
                        for c in cats! {
                            let category = CategoryItem.init(dict: c as! [String: Any])
                            self.categories.append(category)
                        }
                        
                        if cats!.count > 0 {
                            self.tableView.reloadData()
                            self.nextPage += 1
                        }
                    } else {
                        self.tableView.reloadData()
                    }
                }
                KVNProgress.dismiss()
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func configureView() {
        view.isOpaque = false
        let b_height = view.bounds.height
        cellHeight = (b_height - 16 * 2 - 50 - 1)/10
        print("error occured !")
        setTitle()
    }

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top10TableViewCell") as! Top10TableViewCell
        let category = categories[indexPath.row]
        cell.lblRank.text = "\(indexPath.row + 1)"
        cell.lblName.text = category.name
        cell.imgIcon.image = getTypeImage()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = categories[indexPath.row]
        GlobalData.selectedCategory = item
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nav-result"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == categories.count - 1 {
            getCategoryList(type: type, page: nextPage, limit: 20)
        }
    }
    
    func setTitle() {
        let title = NSMutableAttributedString()
        switch type {
        case "restaurant":
            lblTitle.attributedText = title.normalText(NSLocalizedString("top10", comment: "")).coloredText(NSLocalizedString("restaurant", comment: ""))
            break
        case "cafe":
            lblTitle.attributedText = title.normalText(NSLocalizedString("top10", comment: "")).coloredText(NSLocalizedString("caffeShop", comment: ""))
            break
        case "hotel":
            lblTitle.attributedText = title.normalText(NSLocalizedString("top10", comment: "")).coloredText(NSLocalizedString("hotels", comment: ""))
            break
        case "car_rental":
            lblTitle.attributedText = title.normalText(NSLocalizedString("top10", comment: "")).coloredText(NSLocalizedString("carRental", comment: ""))
            break
        case "tourist_attractions":
            lblTitle.attributedText = title.normalText(NSLocalizedString("top10", comment: "")).coloredText(NSLocalizedString("touristAttractions", comment: ""))
            break
        case "other":
            lblTitle.attributedText = title.normalText(NSLocalizedString("top10", comment: "")).coloredText(NSLocalizedString("other", comment: ""))
            break
        default:
            break
        }
    }
    
    func getTypeImage() -> UIImage? {
        switch type {
        case "restaurant":
            return UIImage(named: "restaurant")
        case "cafe":
            return UIImage(named: "cofee-shop")
        case "hotel":
            return UIImage(named: "hotel")
        case "car_rental":
            return UIImage(named: "car-rental")
        case "tourist_attractions":
            return UIImage(named: "tourist")
        case "other":
            return UIImage(named: "other")
        default:
            return nil
        }
    }
}

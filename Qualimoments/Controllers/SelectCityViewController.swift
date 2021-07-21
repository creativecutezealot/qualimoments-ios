//
//  SelectCityViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/23/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class SelectCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchConView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var cities: [QMCity] = []
    var nextPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        getCities(query: "")
    }
    
    func configureView() {
        lblTitle.text = NSLocalizedString("chooseCity", comment: "")
        searchConView.layer.borderColor = UIColor.lightGray.cgColor
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func getCities(page: Int = 0, limit: Int = 20, query: String) {
        APIManager.sharedInstance.getCities(page: page, limit: limit, query: query, completion: {
            error, response in
            KVNProgress.dismiss()
            if error == nil {
                let obj = response as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        
                        let detail = err!["detail"] as! String
                        KVNProgress.showError(withStatus: detail)
                        
                        return
                    }
                    
                    let results = response as! NSDictionary
                    
                    if page == 0 {
                        self.cities = []
                    }
                    
                    let cs = results["cities"] as? NSArray
                    if cs != nil {
                        for c in cs! {
                            let city = QMCity.init(dict: c as! NSDictionary)
                            self.cities.append(city)
                        }
                        if cs!.count > 0 {
                            self.tableView.reloadData()
                            self.nextPage += 1
                        }
                    }
                    else {
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let length = textField.text!.count
        if length > 0 {
            nextPage = 0
            getCities(query: textField.text!)
        } else {
            nextPage = 0
            getCities(query: "")
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell") as! CityTableViewCell
        let city = cities[indexPath.item]
        
        cell.lblCity.text = city.name
        cell.lblCountry.text = city.country.name
        //
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.item]
        GlobalData.curCity = city
        NotificationCenter.default.post(name: Notification.Name(rawValue: "selected-city"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cities.count - 1 {
            getCities(page: nextPage, limit: 20, query: txtSearch.text!)
        }
    }
}

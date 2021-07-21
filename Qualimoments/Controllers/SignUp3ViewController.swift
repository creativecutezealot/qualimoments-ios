//
//  SignUp3ViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/10/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class SignUp3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearchCtrl: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCityCount: UILabel!

    var cities: [QMCity] = []
    var nextPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        for tour in GlobalData.selectedTours {
            for city in cities {
                if tour.id == city.id {
                    city.isSelected = tour.isSelected
                }
            }
        }
        
        getCities(query: "")
    }
    
    func configureView() {
        txtSearch.placeholder = NSLocalizedString("search", comment: "")
        btnDone.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        
        searchView.layer.borderColor = UIColor.gray.cgColor
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        lblCityCount.text = "0"
    }
    
    func getCities(page: Int = 0, limit: Int = 20, query: String) {
//        if page == 0 {
//            KVNProgress.show()
//        }
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
                            self.removeMyCities()
                            self.tableView.reloadData()
                            self.nextPage += 1
                        }
                    }
                    else {
                        self.removeMyCities()
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    func removeMyCities() {
        var index = -1
        for mc in GlobalData.myTours {
            for i in 0..<cities.count {
                if mc.id == cities[i].id {
                    index = i
                    break
                }
            }
            
            if index != -1 {
                cities.remove(at: index)
                index = -1
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let length = textField.text!.count
        if length > 0 {
            btnSearchCtrl.setImage(UIImage(named: "search-close"), for: .normal)
            nextPage = 0
            getCities(query: textField.text!)
        } else {
            btnSearchCtrl.setImage(UIImage(named: "search"), for: .normal)
            nextPage = 0
            getCities(query: "")
//            cities = []
        }
//        tableView.reloadData()
    }
    
    @IBAction func onSearchCtrl(_ sender: Any) {
        btnSearchCtrl.setImage(UIImage(named: "search"), for: .normal)
        txtSearch.text = ""
        txtSearch.resignFirstResponder()
        
        cities = []
        self.removeMyCities()
        tableView.reloadData()
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDone(_ sender: Any) {
        var selectedCities:[QMCity] = []
        for city in cities {
            if city.isSelected {
                selectedCities.append(city)
            }
        }
        
        GlobalData.selectedTours = selectedCities
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh-tours"), object: nil)
        navigationController?.popViewController(animated: true)
    }   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell;
        let city = cities[indexPath.row]
        cell.lblCity.text = city.name
        cell.lblCountry.text = city.country.name
        cell.imgCheck.image = city.isSelected ? UIImage(named: "check-on") : UIImage(named: "check-off")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        city.isSelected = !city.isSelected

        var selected = 0
        for city in cities {
            if city.isSelected {
                selected += 1
            }
        }
        lblCityCount.text = "\(selected)"
        self.removeMyCities()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cities.count - 1 {
            getCities(page: nextPage, limit: 20, query: txtSearch.text!)
        }
    }
}

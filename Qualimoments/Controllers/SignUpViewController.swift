//
//  SignUpViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/10/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnWhere: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalData.myTours = []
        GlobalData.selectedTours = []
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func configureView() {
        txtEmail.placeholder = NSLocalizedString("email", comment: "")
        txtUserName.placeholder = NSLocalizedString("userName", comment: "")
        txtPassword.placeholder = NSLocalizedString("password", comment: "")
        txtConfirm.placeholder = NSLocalizedString("confirmPassword", comment: "")
        btnWhere.setTitle(NSLocalizedString("whereHaveYouBeen", comment: ""), for: .normal)
        btnContinue.setTitle(NSLocalizedString("continue", comment: ""), for: .normal)
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAvatar(_ sender: Any) {
        
    }
    
    @IBAction func onWhere(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp3ViewController") as! SignUp3ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onContinue(_ sender: Any) {
        let email = txtEmail.text!
        let userName = txtUserName.text!
        let password = txtPassword.text!
        let confirm = txtConfirm.text!
        
        if email.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterEmail", comment: ""))
            return
        } else if !CommonManager.sharedInstance.isValidEmail(testStr: email) {
           CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("invalidEmail", comment: ""))
            return
        }
        
        if userName.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterUsername", comment: ""))
            return        }
            
        if password.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterPassword", comment: ""))
            return
        } else if password.count < 6 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("passwordMinLength", comment: ""))
            return
        }
            
        if password != confirm {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("passwordNotMatched", comment: ""))
            return
        }
        
        KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
        APIManager.sharedInstance.signUp(email: email, username: userName, password: password, completion: {(result)-> () in
            KVNProgress.dismiss()
            self.signUpProcess(result: result)
        })
    }
    
    func signUpProcess(result: NSDictionary) {
        
        let error = result["error"] as? NSDictionary
        if error != nil {
            let detail = error!["detail"] as! String
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("error", comment: ""), msg: detail)
        } else {
            print(result)
            let accessToken = result["accessToken"] as! String
            let refreshToken = result["refreshToken"] as! String
            GlobalData.accessToken = accessToken
            GlobalData.refreshToken = refreshToken
            
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
            
            if GlobalData.selectedTours.count == 0 {
                KVNProgress.showSuccess(withStatus: NSLocalizedString("success", comment: ""))
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                navigationController?.pushViewController(vc, animated: true)
            } else {
                updateTours()
            }
            
            
        }
    }
    
    func updateTours() {
        var cities: [Any] = []
        for city in GlobalData.selectedTours {
            cities.append(city.getDict())
        }
        
        APIManager.sharedInstance.updateTours(cities: cities, completion: {
            err, res in
            if err == nil {
                let result = res as! NSDictionary
                let error = result["error"] as? NSDictionary
                if error != nil {
                    let detail = error!["detail"] as! String
                    CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("error", comment: ""), msg: detail)
                } else {
                    KVNProgress.showSuccess(withStatus: NSLocalizedString("success", comment: ""))
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                KVNProgress.showError(withStatus: err?.localizedDescription, on: self.view)
            }
        })
    }
    
}

//
//  LoginViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/19/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        
        if accessToken != nil && refreshToken != nil {
            GlobalData.accessToken = accessToken!
            GlobalData.refreshToken = refreshToken!
            
            gotoMenu(animated: false)
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
//        UIApplication.shared.unregisterForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name:NSNotification.Name(rawValue: "logout"), object: nil)
        
        configureView()
    }
    
    func configureView() {
        txtEmail.placeholder = NSLocalizedString("email", comment: "")
        txtPassword.placeholder = NSLocalizedString("password", comment: "")
        btnLogin.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        btnFacebook.setTitle(NSLocalizedString("loginWithFacebook", comment: ""), for: .normal)
        btnGoogle.setTitle(NSLocalizedString("loginWithGoogle", comment: ""), for: .normal)
        btnSignup.setTitle(NSLocalizedString("signup", comment: ""), for: .normal)
    }
    
    @objc func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if email.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterEmail", comment: ""))
            return
        } else if !CommonManager.sharedInstance.isValidEmail(testStr: email) {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("invalidEmail", comment: ""))
            return
        }
        
        if password.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterPassword", comment: ""))
            return
        } else if password.count < 6 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("passwordMinLength", comment: ""))
            return
        }

        login(provider: "password", email: email, password: password)
    }
    
    func login(provider: String, email: String, password: String) {
        KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""))
        APIManager.sharedInstance.signIn(provider: provider, email: email, password: password, completion: {(result)-> () in
            KVNProgress.dismiss()
            self.signInProcess(result: result)
        })
    }
   
    
    func signInProcess(result: NSDictionary) {
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
            
            gotoMenu(animated: true)
        }
    }
    
    func gotoMenu(animated: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    @IBAction func onFacebook(_ sender: Any) {
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends", "user_birthday"], from: self) {
            result, error in
            if error != nil {
                return
            }
            
            if result != nil {
                if result!.isCancelled {
                    return
                } else {
                    let token = result!.token.tokenString
                    if token != nil {
                        APIManager.sharedInstance.signInWithSocial(provider: "facebook", token: token!, completion: {
                            error, object in
                            
                            if error == nil {
                                if object != nil {
                                    let result = object! as! NSDictionary
                                    self.signInProcess(result: result)
                                }
                            } else {
                                KVNProgress.showError(withStatus: error!.localizedDescription)
                            }
                            
                        })
                    }
                }
            }
            else {
                return
            }
        }
    }
    
    @IBAction func onGoogle(_ sender: Any) {
//        KVNProgress.show(withStatus: "Please wait...")
        KVNProgress.show(withStatus: NSLocalizedString("pleaseWait", comment: ""), on: view)
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

// GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            KVNProgress.dismiss()
            KVNProgress.showError(withStatus: error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        print(authentication)
        
        let token = authentication.idToken
        if token != nil {
            APIManager.sharedInstance.signInWithSocial(provider: "google", token: token!, completion: {
                error, object in
                
                if error == nil {
                    if object != nil {
                        let result = object! as! NSDictionary
                        self.signInProcess(result: result)
                    }
                } else {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
                
            })
        }
    }
}


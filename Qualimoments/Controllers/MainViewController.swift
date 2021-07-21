//
//  MainViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/11/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class MainViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnNews: UIButton!
    @IBOutlet weak var btnNetwork: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    var curVC: UIViewController?
    var curIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()        
        sideMenus()
        openHomePage()
        
        getUserDetail()
        registerPushToken()
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(openHomePage), name:NSNotification.Name(rawValue: "open-home"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openNewsPage), name:NSNotification.Name(rawValue: "open-news"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMessagePage), name:NSNotification.Name(rawValue: "open-messages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSettingsPage), name:NSNotification.Name(rawValue: "open-settings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSearchPage), name:NSNotification.Name(rawValue: "open-search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openNetworkPage), name:NSNotification.Name(rawValue: "open-network"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openNotificationPage), name:NSNotification.Name(rawValue: "open-notifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openUserPage), name:NSNotification.Name(rawValue: "open-user"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeToBack), name:NSNotification.Name(rawValue: "nav-to-category"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentTop10), name:NSNotification.Name(rawValue: "present-top10"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentFindCity), name:NSNotification.Name(rawValue: "present-find-city"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentReview), name:NSNotification.Name(rawValue: "present-review"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentSelectCity), name:NSNotification.Name(rawValue: "present-select-city"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(back), name:NSNotification.Name(rawValue: "pop"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAddTourPage), name:NSNotification.Name(rawValue: "nav-add-tours"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMyPosts), name:NSNotification.Name(rawValue: "nav-to-myposts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerPushToken), name:NSNotification.Name(rawValue: "registerPushToken"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentBugReport), name:NSNotification.Name(rawValue: "present-bug-report"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentFeedback), name:NSNotification.Name(rawValue: "present-send-feedback"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentFaq), name:NSNotification.Name(rawValue: "present-faq"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentPrivacy), name:NSNotification.Name(rawValue: "present-privacy"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentLisence), name:NSNotification.Name(rawValue: "present-lisence"), object: nil)
        
    }
    
    @objc func registerPushToken() {
        if GlobalData.fcmToken.count > 0 {
            APIManager.sharedInstance.registerPushToken(token: GlobalData.fcmToken, completion: {
                error, object in
                if error == nil {
                    let obj = object as? NSDictionary
                    if obj != nil {
                        let err = obj!["error"] as? NSDictionary
                        if err != nil {
                            let status = err!["status"] as! Int
                            if status == 401 {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)                                
                            } else {
                                let detail = err!["detail"] as! String
                                KVNProgress.showError(withStatus: detail)
                            }
                            
                            return
                        }
                        print("FCM Token register Success")
                        print("Token: \(GlobalData.fcmToken)")
                    }
                    
                    KVNProgress.dismiss()
                } else {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
            })
        }
    }
    
    func getUserDetail() {
        KVNProgress.show()
        APIManager.sharedInstance.getMyProfile(completion: {
            error, result in
            if error == nil {
                    
                let obj = result as? NSDictionary
                if obj != nil {
                    let err = obj!["error"] as? NSDictionary
                    if err != nil {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
                        return
                    }
                    
                    GlobalData.curUser = QMUser.init(dict: result as! NSDictionary)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "completed-get-user"), object: nil)
                }               
                
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
            }
            KVNProgress.dismiss()            
        })
    }
    
    func configureView() {
        btnBack.isHidden = true
        btnMenu.isHidden = false
    }

    func sideMenus() {
        if revealViewController() != nil {
            btnMenu.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 280
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    @objc func back() {
        GlobalData.navCount -= 1
        let count = GlobalData.navCount
        print(count)
        if count == 1 {
            btnBack.isHidden = true
            btnMenu.isHidden = false
            setTitle()
        } else {
            btnBack.isHidden = false
            btnMenu.isHidden = true
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        GlobalData.navCount -= 1
        let count = GlobalData.navCount
        print(count)
        if count == 1 {
            btnBack.isHidden = true
            btnMenu.isHidden = false
            setTitle()
        } else {
            btnBack.isHidden = false
            btnMenu.isHidden = true            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "back"), object: nil)
    }
    
    @IBAction func onCamera(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onHome(_ sender: Any) {
        openHomePage()
    }
    
    @IBAction func onNews(_ sender: Any) {        
        openNewsPage()
    }
    
    @IBAction func onNetwork(_ sender: Any) {
        openNetworkPage()
    }
    
    @IBAction func onNotification(_ sender: Any) {
        openNotificationPage()
    }
    
    @IBAction func onUser(_ sender: Any) {
        openUserPage()
    }
    
    @objc func openHomePage() {
        btnHome.setImage(UIImage(named: "home-selected"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)       
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("home", comment: "")
        onShowVC(vc: vc, nextIndex: 0)
    }
    
    @objc func openNewsPage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news-selected"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewsNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("newsFeed", comment: "")
        onShowVC(vc: vc, nextIndex: 1)
    }
    
    @objc func openMessagePage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MessageNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("messages", comment: "")
        onShowVC(vc: vc, nextIndex: 5)
    }
    
    @objc func openSettingsPage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("settings", comment: "")
        onShowVC(vc: vc, nextIndex: 6)
    }
    
    @objc func openSearchPage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("searchPage", comment: "")
        onShowVC(vc: vc, nextIndex: 7)
    }
    
    @objc func openNetworkPage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network-selected"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "NetworkNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("network", comment: "")
        onShowVC(vc: vc, nextIndex: 2)
    }
    
    @objc func openNotificationPage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification-selected"), for: .normal)
        btnUser.setImage(UIImage(named: "user"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("notifications", comment: "")
        onShowVC(vc: vc, nextIndex: 3)
    }
    
    @objc func openUserPage() {
        btnHome.setImage(UIImage(named: "home"), for: .normal)
        btnNews.setImage(UIImage(named: "news"), for: .normal)
        btnNetwork.setImage(UIImage(named: "network"), for: .normal)
        btnNotification.setImage(UIImage(named: "notification"), for: .normal)
        btnUser.setImage(UIImage(named: "user-selected"), for: .normal)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserNav") as! UINavigationController
        GlobalData.title = NSLocalizedString("profile", comment: "")
        onShowVC(vc: vc, nextIndex: 4)
    }
    
    @objc func changeToBack() {
        btnBack.isHidden = false
        btnMenu.isHidden = true
        
        setChildTitle()
    }
    
    func onShowVC(vc: UIViewController, nextIndex: Int) {
        if curIndex != nextIndex {
            setTitle()
            curIndex = nextIndex
            addChildViewController(vc)
            vc.view.frame = containerView.bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vc.didMove(toParentViewController: self)
            containerView.addSubview(vc.view)
            
            if curVC != nil {
                curVC?.view.removeFromSuperview()
            }
            curVC = vc
            
            GlobalData.navCount = 1
            btnBack.isHidden = true
            btnMenu.isHidden = false
        }
    }
    
    func setTitle() {
        lblTitle.text = GlobalData.title
    }
    
    func setChildTitle() {
        lblTitle.text = GlobalData.childTitle
    }
    
    @objc func presentTop10() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Top10ViewController") as! Top10ViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.type = GlobalData.top10Type
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentFindCity() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FindCityViewController") as! FindCityViewController
        vc.modalPresentationStyle = .overCurrentContext        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentReview() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentSelectCity() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectCityViewController") as! SelectCityViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func openAddTourPage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp3ViewController") as! SignUp3ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openMyPosts() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyPostsViewController") as! MyPostsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func presentBugReport() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BugReportViewController") as! BugReportViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentFeedback() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentFaq() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FaqViewController") as! FaqViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentPrivacy() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as! PrivacyViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentLisence() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LicenceViewController") as! LicenceViewController
        self.present(vc, animated: true, completion: nil)
    }
}

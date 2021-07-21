//
//  EditProfileViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 8/6/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import KVNProgress

class EditProfileViewController: UIViewController {
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var userNameConView: UIView!
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var cityConView: UIView!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var descConView: UIView!
    @IBOutlet weak var txtDesc: UITextView!
    
    let imagePickerController = UIImagePickerController()
    var selectedImgData: Data!
    
    var userName = ""
    var userDesc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setCity), name:NSNotification.Name(rawValue: "selected-city"), object: nil)
    }
    
    func configureView() {
        GlobalData.curCity = QMCity()
        userNameConView.layer.borderWidth = 1
        userNameConView.layer.borderColor = UIColor.lightGray.cgColor
        txtUserName.placeholder = NSLocalizedString("userName", comment: "")
        
        cityConView.layer.borderWidth = 1
        cityConView.layer.borderColor = UIColor.lightGray.cgColor
        txtCity.placeholder = NSLocalizedString("city", comment: "")
        
        descConView.layer.borderWidth = 1
        descConView.layer.borderColor = UIColor.lightGray.cgColor
        txtDesc.placeholder = NSLocalizedString("pleaseEnterYourself", comment: "")
        
        imgUser.kf.setImage(with: URL(string: GlobalData.curUser.picture)!, placeholder: UIImage(named: "unknown_user"), options: [.cacheOriginalImage])
        txtUserName.text = GlobalData.curUser.name
        txtDesc.text = GlobalData.curUser.desc
        if GlobalData.curUser.city.name.count > 0 && GlobalData.curUser.city.country.name.count > 0 {
            let city = GlobalData.curUser.city.name + ", " + GlobalData.curUser.city.country.name
            print(city.count)
            txtCity.text = city
        }
        
        userName = GlobalData.curUser.name
        userDesc = GlobalData.curUser.desc
    }
    
    @objc func setCity() {
        if GlobalData.curCity.name.count > 0 && GlobalData.curCity.country.name.count > 0 {
            txtCity.text = GlobalData.curCity.name + ", " + GlobalData.curCity.country.name
        }
        
    }
    
    @IBAction func onChangePicture(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func onCity(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "present-select-city"), object: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        if selectedImgData != nil {
            let filename = getDocumentsDirectory().appendingPathComponent("avatar.jpg")
            do {
                try selectedImgData.write(to: filename)
            } catch {
                print(error.localizedDescription)
            }
//            try? selectedImgData.write(to: filename)
            KVNProgress.show()
            APIManager.sharedInstance.uploadAvatar(file: filename, completion: {
                error, object in
                if error != nil {
                    KVNProgress.showError(withStatus: error!.localizedDescription)
                }
                else {
                    let obj = object as? NSDictionary
                    
                    if obj != nil {
                        let err = obj!["error"] as? NSDictionary
                        if err != nil {
                            let detail = err!["detail"] as! String
                            KVNProgress.showError(withStatus: detail)
                            return
                        }
                        
                        KVNProgress.dismiss()
                        
                        if self.userName != self.txtUserName.text || self.userDesc != self.txtDesc.text {
                            self.changePofile()
                        }
                        else if GlobalData.curCity.id.count > 0 {
                            self.changePofile()
                        }
                        else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "pop"), object: nil)
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload-profile"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })
        }
        else {
            if userName != self.txtUserName.text || userDesc != self.txtDesc.text {
                changePofile()
            }
            else if GlobalData.curCity.id.count > 0 {
                changePofile()
            }
            else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "pop"), object: nil)
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "reload-profile"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
//
    }
    
    func changePofile() {
        let user = GlobalData.curUser
        let seconds = Int64(NSDate().timeIntervalSince1970 * 1000)
        
        var body = [
            "id": user.id,
            "name": txtUserName.text!,
            "externalEmail": user.externalEmail,
            "externalId": user.externalId,
            "description": txtDesc.text!,
            "provider": user.provider,
            "friendsCount": user.friendsCount,
            "toursCount": user.toursCount,
            "reviewsCount": user.reviewsCount,
            "newMessagesCount": user.newMessagesCount,
            "picture": user.picture,
            "createdAt": user.createdAt,
            "updatedAt": seconds,
            "type": user.type,
            "postsCount": user.postsCount,
            "connected": user.connected
            
            ] as [String : Any]
        
        if GlobalData.curCity.id.count > 0 {
            body["city"] = GlobalData.curCity.getDict()
        }
        
        KVNProgress.show()
        APIManager.sharedInstance.changeProfile(body: body, completion: {
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
                    
                    KVNProgress.dismiss()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "pop"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reload-profile"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else {
                KVNProgress.showError(withStatus: error!.localizedDescription)
            }
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        image = image!.resizeImage(targetSize: CGSize(width: 150, height: 150))
        selectedImgData = UIImageJPEGRepresentation(image!, 0.5)
        self.imgUser.image = image
        print(image!.size.height, image!.size.width)
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

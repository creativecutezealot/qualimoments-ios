//
//  NewPostViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/7/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import CropViewController
import KVNProgress

class NewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUploadPhoto: UILabel!
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var tagConView: WSTagsField!
    @IBOutlet weak var tagView: WSTagsField!
    @IBOutlet weak var textDesc: UITextView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    
    var tags: [WSTag] = []
    let imagePickerController = UIImagePickerController()
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        lblTitle.text = NSLocalizedString("newPost", comment: "")
        lblUploadPhoto.text = NSLocalizedString("uploadPhoto", comment: "")
        btnUpload.setTitle(NSLocalizedString("upload", comment: ""), for: .normal)
        
        tagConView.layer.borderWidth = 1
        tagConView.layer.borderColor = UIColor.lightGray.cgColor
        textDesc.layer.borderWidth = 1
        textDesc.layer.borderColor = UIColor.lightGray.cgColor
        textDesc.placeholder = NSLocalizedString("writeDesciption", comment: "")
        textDesc.delegate = self
        
        tagConView.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagConView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagConView.spaceBetweenLines = 5.0
        tagConView.spaceBetweenTags = 10.0
        
        tagConView.font = .systemFont(ofSize: 14.0)
        tagConView.backgroundColor = .white
        tagConView.tintColor = .white
        tagConView.textColor = .black
        tagConView.fieldTextColor = .black
        tagConView.selectedColor = UIColor(red: 105/255, green: 174/255, blue: 224/255, alpha: 1.0)
        tagConView.selectedTextColor = .white
        tagConView.delimiter = ""
        tagConView.isDelimiterVisible = true
        tagConView.placeholderColor = .gray
        tagConView.placeholderAlwaysVisible = false
        tagConView.returnKeyType = .next
        tagConView.acceptTagOption = .space
        tagConView.placeholder = NSLocalizedString("tagPleaceholder", comment: "")
        tagConView.borderWidth = 1
        tagConView.borderColor = UIColor(red: 105/255, green: 174/255, blue: 224/255, alpha: 1.0)
        tagConView.cornerRadius = 10
        tagConView.numberOfLines = 1        
        
        tagConView.onDidAddTag = { (_,tag) in
            self.tags.append(tag)
        }
        
        tagConView.onDidRemoveTag = { (_,tag) in
            
            if self.tags.count > 0 {
                var index = -1
                for i in 0...self.tags.count - 1 {
                    if tag == self.tags[i] {
                        index = i
                        break
                    }
                }
                
                if index != -1 {
                    self.tags.remove(at: index)
                }
            }
        }
        
        tagConView.onDidChangeText = { _, text in
            print("DidChangeText")
        }
        
        tagConView.onDidChangeHeightTo = { sender, height in
            print("HeightTo \(height)")
        }
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddPicture(_ sender: Any) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func onUpload(_ sender: Any) {
        if img == nil {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseSelectPhoto", comment: ""))
            return
        }
        if tags.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterTag", comment: ""))
            return
        }
        let desc = textDesc.text!
        if desc.count == 0 {
            CommonManager.sharedInstance.showAlert(viewCtrl: self, title: NSLocalizedString("warning", comment: ""), msg: NSLocalizedString("pleaseEnterDescription", comment: ""))
            return
        }
        
        var ts:[String] = []
        for t in self.tags {
            ts.append(t.text)
        }
        
        let body = [
            "description": desc,
            "tags": ts
            ] as [String : Any]
        
        KVNProgress.show()
        
        let selectedImgData = UIImageJPEGRepresentation(self.img!, 0.5)
        let filename = self.getDocumentsDirectory().appendingPathComponent("post.jpg")
        do {
            try selectedImgData!.write(to: filename)
        } catch {
            print(error.localizedDescription)
        }
        
        APIManager.sharedInstance.newPost(file: filename, body: body, completion: {
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
                    
                    KVNProgress.showSuccess()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        })
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 70
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lblCount.text = "\(textView.text.count)/70"
    }
}

extension NewPostViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        imagePickerController.dismiss(animated: true, completion: nil)
        
        let cropViewController = CropViewController(image: image!)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }
}

extension NewPostViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        img = image
        
        imgPicture.image = image
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
}





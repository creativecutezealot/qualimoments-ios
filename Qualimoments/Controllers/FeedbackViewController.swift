//
//  FeedbackViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 9/16/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, FloatRatingViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var ratingConView: UIView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var txtFeedback: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        lblTitle.text = NSLocalizedString("feedback", comment: "")
        lblDescription.text = NSLocalizedString("feedbackDesc", comment: "")
        btnSubmit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
        txtFeedback.placeholder = NSLocalizedString("pleaseEnterFeedback", comment: "")
        
        ratingConView.layer.borderWidth = 1
        ratingConView.layer.borderColor = UIColor.lightGray.cgColor
        
        txtFeedback.layer.borderWidth = 1
        txtFeedback.layer.borderColor = UIColor.lightGray.cgColor
        
        self.ratingView.emptyImage = UIImage(named: "star-blue")
        self.ratingView.fullImage = UIImage(named: "star-red")
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.rating = 0
        self.ratingView.editable = true
        self.ratingView.halfRatings = false
        self.ratingView.floatRatings = true
    }

    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        
//        print(NSString(format: "%.2f", self.ratingView.rating) as String)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
//        print(NSString(format: "%.2f", self.ratingView.rating) as String)
    }
}

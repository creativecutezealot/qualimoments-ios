//
//  ContentViewController.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/14/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import UIKit
import ISHPullUp
class ContentViewController: UIViewController, ISHPullUpContentDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func pullUpViewController(_ vc: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController _: UIViewController) {
//        if #available(iOS 11.0, *) {
//            additionalSafeAreaInsets = edgeInsets
//            rootView.layoutMargins = .zero
//        } else {
//            // update edgeInsets
//            rootView.layoutMargins = edgeInsets
//        }
//
//        // call layoutIfNeeded right away to participate in animations
//        // this method may be called from within animation blocks
//        rootView.layoutIfNeeded()
    }

}

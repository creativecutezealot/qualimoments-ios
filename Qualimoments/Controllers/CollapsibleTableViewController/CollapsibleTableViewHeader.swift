//
//  CollapsibleTableViewHeader.swift
//  CollapsibleTableSectionViewController
//
//  Created by Yong Su on 7/20/17.
//  Copyright © 2017 jeantimex. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ section: Int)
}

open class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    let titleLabel = UILabel()
    let arrowImage = UIImageView()
    let typeImage = UIImageView()
    let underlineView = UIView()
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = UIColor.white//UIColor(hex: 0x2E3944)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        // Arrow label
        contentView.addSubview(arrowImage)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: 12).isActive = true
        arrowImage.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        contentView.addSubview(typeImage)
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        typeImage.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 8).isActive = true
        typeImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        typeImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
        typeImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 8).isActive = true
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.textColor = UIColor(hex: 0x67afe0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: arrowImage.layoutMarginsGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 1).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: typeImage.layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
        
        
        contentView.addSubview(underlineView)
        underlineView.backgroundColor = UIColor.gray
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        //
        // Call tapHeader when tapping on this header
        //
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        
        _ = delegate?.toggleSection(cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        //
        // Animate the arrow rotation (see Extensions.swf)
        //
        arrowImage.rotate(collapsed ? 0.0 : .pi)
    }
    
}

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}



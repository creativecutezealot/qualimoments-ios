//
//  Extension.swift
//  Qualimoments
//
//  Created by Zheng Cheng on 7/11/18.
//  Copyright © 2018 Techtify. All rights reserved.
//

import Foundation
extension String {
    func commonPrefix(with other: String) -> String {
        return String(zip(self, other).prefix(while: { $0.0 == $0.1 }).map { $0.0 })
    }
}

extension NSMutableAttributedString {
    
    @discardableResult func coloredText(_ text:String)->NSMutableAttributedString {
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor(red: 103/255, green: 175/255, blue: 224/255, alpha: 1.0),
                            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0) ]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute)
        self.append(myAttrString)
        return self
    }
    
    @discardableResult func normalText(_ text:String)->NSMutableAttributedString {
        let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.darkGray, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0)  ]
        let myAttrString = NSAttributedString(string: text, attributes: myAttribute)
        self.append(myAttrString)
        return self
    }
    
    
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let width = targetSize.width
        let height = targetSize.height
//        if self.size.width >= self.size.height {
//           height = width * self.size.height / self.size.width
//        }
//        else {
//            width = height * self.size.width / self.size.height
//        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let newSize = CGSize(width: width, height: height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}



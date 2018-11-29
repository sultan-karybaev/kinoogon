//
//  UISlider.swift
//  Kinoogon
//
//  Created by Sultan Karybaev on 11/29/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

extension UISlider {
    
    func setCircle() {
        let icon = UIImage(named: "circular-shape-silhouette")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 10), false, 1.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: 10, height: 10))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        
        setThumbImage(newImage, for: .normal)
        setThumbImage(newImage, for: .focused)
        setThumbImage(newImage, for: .selected)
        setThumbImage(newImage, for: .application)
        setThumbImage(newImage, for: .disabled)
        setThumbImage(newImage, for: .highlighted)
        setThumbImage(newImage, for: .reserved)
        tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
    }
    
}
